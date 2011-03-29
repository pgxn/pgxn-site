#!/usr/bin/env perl -w

use 5.12.0;
use utf8;
#use Test::More tests => 28;
use Test::More 'no_plan';
use Plack::Test;
use HTTP::Request::Common;
use Test::File::Contents;
use Test::MockModule;
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

# Test /search.
test_psgi $app => sub {
    my $cb = shift;

    # Set up some mock search results.
    # Mock the search.
    my $mocker = Test::MockModule->new('WWW::PGXN');
    my %params;
    $mocker->mock(search => sub {
        my ($self, %p) = @_;;
        %params = %p;
        return {
            query  => "ordered pair",
            limit  => 50,
            offset => 0,
            count  => 0,
            index  => $p{index} || 'doc',
            hits   => [],
        };
    });

    # Search for stuff.
    for my $index ('', qw(doc dist extension user tag)) {
        for my $spec (
            [ 'q=föö' => {} ],
            [ 'q=föö&o=2' => { offset => 2} ],
            [ 'q=föö&o=2&l=3' => { offset => 2, limit => 3} ],
            [ 'q=föö&l=3' => { limit => 3} ],
        ) {
            my $uri = "/search?$spec->[0]&in=$index";
            ok my $res = $cb->(GET $uri), "Fetch $uri";
            ok $res->is_success, 'Request should be successful';
            is_deeply \%params, {
                query => 'föö',
                index => $index,
                limit => undef,
                offset => undef,
                %{ $spec->[1] },
            }, 'Proper paarams shold be passed to WWW::PGXN';
            like $res->content, qr{<h3>Search matched no documents\.</h3>},
                'Should look like search results';
        }
    }

    # Make sure no q returns 400.
    ok my $res = $cb->(GET '/search'), 'Fetch /search without q=';
    ok $res->is_error, 'Should return an error';
    is $res->code, 400, 'Should get 400 response';
    like decode_utf8($res->content),
        qr{<p class="error">Bad request: Missing or invalid “q” query parameter\.</p>},
        'The body should have the invalid q param error';

    # Make sure an invalid "in" value resturns 400.
    ok my $res = $cb->(GET '/search?q=whu&in=foo'), 'Fetch /search with bad in=';
    ok $res->is_error, 'Should return an error';
    is $res->code, 400, 'Should get 400 response';
    like decode_utf8($res->content),
        qr{<p class="error">Bad request: Missing or invalid “in” query parameter\.</p>},
        'The body should have the invalid in param error';
};
