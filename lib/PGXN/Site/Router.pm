package PGXN::Site::Router v0.1.0;

use 5.12.0;
use utf8;
use PGXN::Site::Templates;
use Router::Resource;
use Plack::Builder;
use Plack::Request;
use Plack::App::File;
use Encode;

Template::Declare->init( dispatch_to => ['PGXN::Site::Templates'] );

sub app {
    builder {
        my $files = Plack::App::File->new(root => './www/ui/');
        mount '/' => sub {
            my $req = Plack::Request->new(shift);
            my $res = $req->new_response(200);
            $res->content_type('text/html; charset=UTF-8');
            $res->body(encode_utf8 +Template::Declare->show('/home', $req));
            return $res->finalize;
        };
        mount '/ui' => $files;
    }
}

1;

