#!/usr/bin/env perl -w

use 5.12.0;
use utf8;
use Test::More;

BEGIN {
    for my $mod (qw(
        Test::XML
        Test::XPath
        HTTP::Request::Common
     )) {
        eval "use $mod;";
        plan skip_all => "$mod required for template testing" if $@;
    }
}

use PGXN::Site::Templates;
use Plack::Request;
use HTTP::Message::PSGI;

plan 'no_plan';
#plan tests => 6;

Template::Declare->init( dispatch_to => ['PGXN::Site::Templates'] );

ok my $req = Plack::Request->new(req_to_psgi(GET '/')),
    'Create a Plack request object';
my $mt = PGXN::Site::Locale->accept($req->env->{HTTP_ACCEPT_LANGUAGE});

ok my $html = Template::Declare->show('home', $req, {}),
    'Call the home template';

is_well_formed_xml $html, 'The HTML should be well-formed';

my $tx = test_wrapper($html, {
});
#diag $html;


sub test_wrapper {
    my $tx = Test::XPath->new( xml => shift, is_html => 1 );
    my $p = shift;

    # Some basic sanity-checking.
    $tx->is( 'count(/html)',      1, 'Should have 1 html element' );
    $tx->is( 'count(/html/head)', 1, 'Should have 1 head element' );
    $tx->is( 'count(/html/body)', 1, 'Should have 1 body element' );

    # Check the head element.
    $tx->ok('/html/head', 'Test head', sub {
        $tx->is('count(./*)', 6, qq{Should have 6 elements below "head"});
        $tx->is(
            './meta[@name="keywords"]/@content',
            'PostgreSQL, extensions, PGXN, PostgreSQL Extension Network',
            'Should have keywords meta element',
        );
        $tx->is(
            './meta[@name="description"]/@content',
            'Search all indexed extensions, distributions, users, and tags on the PostgreSQL Extension Network.',
            'Should have description meta element',
        );

        for my $spec (
            [ html   => 'screen, projection, tv' ],
            [ layout => 'screen, projection, tv' ],
            [ print  => 'print'                  ],
        ) {
            $tx->is(
                qq{./link[\@href="/ui/css/$spec->[0].css"]/\@rel},
                'stylesheet',
                "$spec->[0] should be stylesheet"
            );
            $tx->is(
                qq{./link[\@href="/ui/css/$spec->[0].css"]/\@type},
                'text/css',
                "$spec->[0] should be text/css"
            );
            $tx->is(
                qq{./link[\@href="/ui/css/$spec->[0].css"]/\@media},
                $spec->[1],
                "$spec->[0] should be for $spec->[1]"
            );
        }
    }); # /head

    # Test the body.
    $tx->is('count(/html/body/*)', 2, 'Should have two elements below body');

    # Check the "header" section.
    $tx->ok('/html/body/div[@id="all"]/div[@id="header"]', 'Test header', sub {
        $tx->ok('./div[@id="title"]', 'Test title', sub {
            $tx->is('./h1', 'PGXN', 'Should have h1');
            $tx->is('./h2', 'PostgreSQL Extension Network', 'Should have h2');
        });
        $tx->ok('./a[@rel="home"]', 'Test home', sub {
            $tx->is('./@href', '/', 'href should be /');
            $tx->is('count(./*)', 2, 'Should have two sub-elements');
            $tx->is('count(./img)', 2, 'And both should be images');
            $tx->ok('./img[1]', 'Test first image', sub {
                $tx->is('./@src', '/ui/img/gear.png', '... Src should be gear.png');
                $tx->is('./@alt', 'PGXN Gear', '... Alt should be "PGXN Gear"');
            });
            $tx->ok('./img[2]', 'Test second image', sub {
                $tx->is('./@src', '/ui/img/pgxn.png', '... Src should be pgxn.png');
                $tx->is(
                    './@alt',
                    'PostgreSQL Extension Network',
                    '... Alt should be "PostgreSQL Extension Network"'
                );
                $tx->is('./@class', 'right', '... Class should be "right"');
            });
        });
    });



    return $tx;
}
