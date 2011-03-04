#!/usr/bin/env perl -w

use 5.12.0;
use utf8;
#use Test::More tests => 28;
use Test::More 'no_plan';
use Plack::Test;
use HTTP::Request::Common;
use Test::File::Contents;
use Encode;

BEGIN {
    use_ok 'PGXN::Site::Router' or die;
}

# Test home page.
test_psgi +PGXN::Site::Router->app => sub {
    my $cb = shift;
    ok my $res = $cb->(GET '/'), 'Fetch /';
    is $res->code, 200, 'Should get 200 response';
    like $res->content, qr/PGXN:/, 'The body should look correct';
};

# Test static file.
test_psgi +PGXN::Site::Router->app => sub {
    my $cb = shift;
    ok my $res = $cb->(GET '/ui/css/html.css'), 'Fetch /pub/ui/css/html.css';
    is $res->code, 200, 'Should get 200 response';
    file_contents_is 'www/ui/css/html.css', $res->content,
        'The file should have been served';
};

# Test bogus URL.
test_psgi +PGXN::Site::Router->app => sub {
    my $cb = shift;
    ok my $res = $cb->(GET '/nonexistentpage'), 'Fetch /nonexistentpage';
    is $res->code, 404, 'Should get 404 response';
    like decode_utf8($res->content), qr/Resource not found\./,
        'The body should have the error';
};
