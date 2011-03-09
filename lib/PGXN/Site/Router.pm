package PGXN::Site::Router v0.1.0;

use 5.12.0;
use utf8;
use PGXN::Site::Controller;
use Router::Resource;
use Plack::Builder;
use Plack::App::File;

sub app {
    my $class = shift;
    my $controller = PGXN::Site::Controller->new(@_);
    my $files      = Plack::App::File->new(root => './www/ui/');
    my $router = router {
        missing { $controller->missing(@_) };
        resource qr{/dist/([^/]+)(?:/([^/]+))/?} => sub {
            GET {
                my ($env, $args) = @_;
                $controller->distribution($env, @{ $args->{splat} } );
            };
        };
        resource qr{/(?:index[.]html)?$} => sub {
            GET { $controller->home(@_) }
        };
    };

    builder {
        mount '/'   => builder { sub { $router->dispatch(shift) } };
        mount '/ui' => $files;
    }
}

1;

=head1 Name

PGXN::Site::Router - The PGXN::Site request router.

=head1 Synopsis

  # In app.pgsi
  use PGXN::Site::Router;
  PGXN::Site::Router->app;

=head1 Description

This class defines the HTTP request routing table used by PGXN::Site. Unless
you're modifying the PGXN::Site routes and controllers, you won't have to
worry about it. Just know that this is the class that Plack uses to fire up
the app.

=head1 Interface

=head2 Class Methods

=head3 C<app>

  PGXN::Site->app;

Returns the PGXN::Site Plack app. See F<bin/pgxn_site.pgsgi> for an example
usage. It's not much to look at. But Plack uses the returned code reference to
power the application.

=head1 Author

David E. Wheeler <david.wheeler@pgexperts.com>

=head1 Copyright and License

Copyright (c) 2011 David E. Wheeler.

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
