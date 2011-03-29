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

local $@;
eval { PGXN::Site::Router->app };
is $@, "Missing required parameters api_url, errors_to and errors_from\n",
    'Should get proper error for missing parameters';

ok my $app = PGXN::Site::Router->app(
    api_url         => 'http://api.pgxn.org/',
    private_api_url => 'file:t/api',
    errors_to       => 'alerts@pgxn.org',
    errors_from     => 'api@pgxn.org',
), 'Instantiate the app';

# Test home page.
test_psgi $app => sub {
    my $cb = shift;
    ok my $res = $cb->(GET '/'), 'Fetch /';
    is $res->code, 200, 'Should get 200 response';
    like $res->content, qr/PGXN:/, 'The body should look correct';
};

# Test static file.
test_psgi $app => sub {
    my $cb = shift;
    ok my $res = $cb->(GET '/ui/css/html.css'), 'Fetch /pub/ui/css/html.css';
    is $res->code, 200, 'Should get 200 response';
    file_contents_is 'lib/PGXN/Site/ui/css/html.css', $res->content,
        'The file should have been served';
};

# Test bogus URL.
test_psgi $app => sub {
    my $cb = shift;
    ok my $res = $cb->(GET '/nonexistentpage'), 'Fetch /nonexistentpage';
    is $res->code, 404, 'Should get 404 response';
    like decode_utf8($res->content), qr/Resource not found\./,
        'The body should have the error';
};
