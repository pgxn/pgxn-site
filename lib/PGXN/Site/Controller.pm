package PGXN::Site::Controller;

use 5.12.0;
use utf8;
#use aliased 'PGXN::Site::Request';
use Plack::Request;
use Plack::Response;
use PGXN::Site::Locale;
use PGXN::Site::Templates;
use Encode;
use WWW::PGXN;
use namespace::autoclean;

Template::Declare->init( dispatch_to => ['PGXN::Site::Templates'] );

# my %message_for = (
#     success     => q{Success},
#     forbidden   => q{Sorry, you do not have permission to access this resource.},
#     notfound    => q{Resource not found.},
#     notallowed  => q{The requted method is not allowed for the resource.},
#     conflict    => q{There is a conflict in the current state of the resource.}, # Bleh
#     gone        => q{The resource is no longer available.},
#     servererror => q{Internal server error.}
# );

my %code_for = (
    success     => 200,
    seeother    => 303,
    badrequest  => 400,
    forbidden   => 403,
    notfound    => 404,
    notallowed  => 405,
    conflict    => 409,
    gone        => 410,
    servererror => 200, # Only handled by ErrorDocument, which keeps 500.
);

sub new {
    my ($class, %p) = @_;

    unless ($p{api_url} && $p{errors_to} && $p{errors_from} && $p{feedback_to}) {
        die "Missing required parameters api_url, errors_to, errors_from, and feedback_to\n";
    }

    (my $api_url = $p{api_url}) =~ s{/$}{};
    bless {
        errors_to   => $p{errors_to},
        errors_from => $p{errors_from},
        feedback_to => $p{feedback_to},
        api_url     => URI->new($api_url),
        api         => WWW::PGXN->new(
            url   =>  $p{private_api_url} || $api_url,
            proxy => $p{proxy_url}
        )
    } => $class;
}

sub api         { shift->{api}         }
sub api_url     { shift->{api_url}     }
sub errors_to   { shift->{errors_to}   }
sub errors_from { shift->{errors_from} }
sub feedback_to { shift->{feedback_to}   }

sub render {
    my ($self, $template, $p) = @_;
    my $req = $p->{req} ||= Plack::Request->new($p->{env});
    my $res = $req->new_response($p->{code} || 200);
    $res->content_type($p->{type} || 'text/html; charset=UTF-8');
    $res->body(encode_utf8 +Template::Declare->show($template, $p->{req}, $p->{vars}));
    $res->finalize;
}

sub missing {
    my ($self, $env) = @_;
    $self->render('/notfound', { env => $env, code => $code_for{notfound} });
}

sub home {
    my $self = shift;
    $self->render('/home', { env => shift });
}

sub feedback {
    my $self = shift;
    $self->render('/feedback', { env => shift, vars => {
        feedback_to => $self->feedback_to
    } });
}

sub about {
    my $self = shift;
    $self->render('/about', { env => shift });
}

sub backers {
    my $self = shift;
    $self->render('/backers', { env => shift });
}

sub distribution {
    my ($self, $env, $name, $version) = @_;
    my $dist = $self->api->get_distribution($name => $version)
        or return $self->missing($env);

    $self->render('/distribution', { env => $env, vars => {
        dist      => $dist,
        api_url   => $self->api_url,
        dist_name => $version ? "$name $version" : $name,
    }});
}

sub document {
    my ($self, $env, $name, $version, $path) = @_;
    my $dist = $self->api->get_distribution($name => $version)
        or return $self->missing($env);
    $path =~ s/[.]html$//;
    my $doc = $dist->body_for_doc($path) or return $self->missing($env);

    my ($dist_uri, $dist_name) = $version
        ? ("/dist/$name/$version/", "$name $version")
        : ("/dist/$name/", $name);
    $self->render('/document', { env => $env, vars => {
        dist      => $dist,
        doc       => $path,
        body      => $doc,
        dist_uri  => $dist_uri,
        dist_name => $dist_name,
    }});
}

sub user {
    my ($self, $env, $nick) = @_;
    my $user = $self->api->get_user($nick) or return $self->missing($env);

    $self->render('/user', { env => $env, vars => {
        user    => $user,
        api     => $self->api,
        api_url => $self->api_url,
    }});
}

sub tag {
    my ($self, $env, $tag) = @_;
    $tag = $self->api->get_tag($tag) or return $self->missing($env);

    $self->render('/tag', { env => $env, vars => {
        tag     => $tag,
        api     => $self->api,
        api_url => $self->api_url,
    }});
}

sub extension {
    my ($self, $env, $ext) = @_;
    $ext = $self->api->get_extension($ext) or return $self->missing($env);
    my $data = $ext->{$ext->{latest}};
    my $uri = "/dist/$data->{dist}/";
    $uri .= "$data->{doc}.html" if $data->{doc};
    my $res = Plack::Response->new;
    $res->redirect($uri, $code_for{seeother});
    $res->finalize;
}

sub search {
    my ($self, $env) = @_;
    my $req = Plack::Request->new($env);
    my $params = $req->query_parameters;
    my $q = $params->{q};

    unless ($q && $params->{in} ~~ ['', undef, qw(docs dists extensions users tags)]) {
        return $self->render('/badrequest', {
            env => $env,
            code => $code_for{badrequest},
            vars => { param => $q ? 'in' : 'q' },
        });
    }

    for my $param (qw(o l)) {
        my $val = $params->{$param};
        return $self->render('/badrequest', {
            env => $env,
            code => $code_for{badrequest},
            vars => { param => $param },
        }) if $val && $val !~ /^\d+$/;
    }

    $self->render('/search', { req => $req, vars => {
        in      => $params->{in},
        api     => $self->api,
        results => $self->api->search(
            in     => $params->{in},
            query  => decode_utf8($q),
            offset => $params->{o},
            limit  => $params->{l},
        ),
    }});
}

sub server_error {
    my ($self, $env) = @_;

    # Pull together the original request environment.
    my $err_env = { map {
        my $k = $_;
        s/^psgix[.]errordocument[.]//
            ? /plack[.]stacktrace[.]/ ? () : ($_ => $env->{$k} )
            : ();
    } keys %{ $env } };
    my $uri = Plack::Request->new($err_env)->uri;

    if (%{ $err_env }) {
        # Send an email to the administrator.
        require Email::MIME;
        require Email::Sender::Simple;
        require Data::Dump;
        my $email = Email::MIME->create(
            header     => [
                From    => $self->errors_from,
                To      => $self->errors_to,
                Subject => 'PGXN Internal Server Error',
            ],
            attributes => {
                content_type => 'text/plain',
                charset      => 'UTF-8',
            },
            body    => "An error occurred during a request to $uri.\n\n"
                     . "Environment:\n\n" . Data::Dump::pp($err_env)
                     . "\n\nTrace:\n\n"
                     . ($env->{'plack.stacktrace.text'} || 'None found. :-(')
                     . "\n",
        );
        Email::Sender::Simple->send($email);
    }

    $self->render('/servererror', { env => $env });
 }

1;

=head1 Name

PGXN::Site::Controller - The PGXN::Site request controller

=head1 Synopsis

  use PGXN::Site::Controller;
  use Router::Resource;

  my $controller = PGXN::Site::Controller->new(url => 'http://api.pgxn.org');
  my $router = router {
      resource '/' => sub {
          GET { $controller->home(@_) };
      };
  };

=head1 Description

This class defines controller actions for PGXN::Site requests. It's designed
to be called from within Router::Resource HTTP methods.

=head1 Interface

=head2 Constructor

=head3 C<new>

  my $controller = PGXN::Site::Controller->new(url => $private_api_url);

Constructs and returns a new controller. The parameters are the same as those
supported by L<WWW::PGXN>, which will be used to fetch the data needed to
serve pages.

=head2 Accessors

=head3 C<api>

Returns a L<WWW::PGXN> object used to access the PGXN API.

=head2 Actions

=head3 C<home>

  PGXN::Site::Controller->home($env);

Displays the HTML for the home page.

=head3 C<distribution>

  PGXN::Site::Controller->distribution($env);

Displays the HTML for the distribution page.

=head3 C<server_error>

Handles subrequests from L<Plack::Middleware::ErrorDocument> when a 500 is
returned. Best way to set it up is to add these three middlewares to the
production configuration file:

    "middleware": [
        ["ErrorDocument", 500, "/error", "subrequest", 1],
        ["HTTPExceptions"],
        ["StackTrace", "no_print_errors", 1]
    ],

=head2 Methods

=head3 C<render>

  $controller->render('/home', $req, @template_args);

Renders the response to the request using L<PGXN::Site::Templates>.

=head3 C<redirect>

  $controller->render('/home', $req);

Redirect the request to a new page.

=head3 C<missing>

  $controller->missing($env, $data);

Handles 404 and 405 errors from Router::Resource.

=over

=item C<success>

=item C<forbidden>

=item C<notfound>

=back

=head1 Author

David E. Wheeler <david.wheeler@pgexperts.com>

=head1 Copyright and License

Copyright (c) 2010-2011 David E. Wheeler.

This module is free software; you can redistribute it and/or modify it under
the L<PostgreSQL License|http://www.opensource.org/licenses/postgresql>.

Permission to use, copy, modify, and distribute this software and its
documentation for any purpose, without fee, and without a written agreement is
hereby granted, provided that the above copyright notice and this paragraph
and the following two paragraphs appear in all copies.

In no event shall David E. Wheeler be liable to any party for direct,
indirect, special, incidental, or consequential damages, including lost
profits, arising out of the use of this software and its documentation, even
if David E. Wheeler has been advised of the possibility of such damage.

David E. Wheeler specifically disclaims any warranties, including, but not
limited to, the implied warranties of merchantability and fitness for a
particular purpose. The software provided hereunder is on an "as is" basis,
and David E. Wheeler has no obligations to provide maintenance, support,
updates, enhancements, or modifications.

=cut
