package PGXN::Site::Router v0.1.0;

use 5.12.0;
use utf8;
use PGXN::Site::Controller;
use Router::Resource;
use Plack::Builder;
use Plack::App::File;
use Encode;

sub app {
    builder {
        my $files      = Plack::App::File->new(root => './www/ui/');
        my $controller = PGXN::Site::Controller->new;
        my $router = router {
            missing { $controller->missing(@_) };
            resource '/' => sub { GET { $controller->home(@_) } };
        };
        mount '/'   => builder { sub { $router->dispatch(shift) } };
        mount '/ui' => $files;
    }
}

1;

