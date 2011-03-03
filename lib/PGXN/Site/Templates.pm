package PGXN::Site::Templates;

use 5.12.0;
use utf8;
use parent 'Template::Declare';
use Template::Declare::Tags;

BEGIN { create_wrapper wrapper => sub {
    my ($code, $req, $args) = @_;
    outs_raw '<!DOCTYPE html>';
    html {
        attr {
            xmlns      => 'http://www.w3.org/1999/xhtml',
            'xml:lang' => 'en',
            lang       => 'en',
        };
        outs_raw( "\n", join "\n",
            '<!--',
            '____________________________________________________________',
            '|                                                            |',
            '|    DESIGN + Pat Heard { http://fullahead.org }             |',
            '|      DATE + 2006.03.19                                     |',
            '| COPYRIGHT + Free use if this notice is left in place       |',
            '|____________________________________________________________|',
            '-->'
        );

        head {
            title { 'PGXN: PostgreSQL Extension Network' };
            meta {
                name is 'keywords';
                content is 'PostgreSQL, extensions, PGXN, PostgreSQL Extension Network';
            };
            meta {
                name is 'description';
                content is 'Search all indexed extensions, distributions, '
                         . 'owners, and tags on the PostgreSQL Extension Network.';
            };
            for my $spec (
                [ html   => 'screen, projection, tv' ],
                [ layout => 'screen, projection, tv' ],
                [ print  => 'print'                  ],
            ) {
                link {
                    rel   is 'stylesheet';
                    type  is 'text/css';
                    href  is "ui/css/$spec->[0].css";
                    media is $spec->[1];
                };
            }
        }; # /head

        body {
            # HEADER: Holds title, subtitle and header images -->
            div {
                id is 'all';
                div {
                    id is 'header';
                    div {
                        id is 'title';
                        h1 { 'PGXN' };
                        h2 { 'PostgreSQL Extension Network' };
                    };
                    a {
                        href is '/';
                        rel is 'home';
                        img {
                            src   is '/ui/img/gear.png';
                            alt   is 'PGXN Gear';
                            class is 'gear';
                        };
                        img {
                            src   is '/ui/img/pgxn.png';
                            alt   is 'PostgreSQL Extension Network';
                            class is 'right';
                        };
                    };
                }; # /div#header
                # CONTENT: Holds all site content except for the footer. This
                # is what causes the footer to stick to the bottom
                div {
                    id is 'content';
                    # MAIN MENU: Top horizontal menu of the site. Use
                    # class="here" to turn the current page tab on.
                    div {
                        id is 'mainMenu';
                        ul {
                            class is 'floatRight';
                            # XXX Fill in these links.
                            for my $spec (
                                [ '#', 'About PGXN',                 'About'  ],
                                [ '#', 'Owners',                     'Owners' ],
                                [ '#', 'Recent Uploads',             'Recent' ],
                                [ '#', 'News',                       'News'   ],
                                [ '#', 'Frequently Asked Questions', 'FAQ'    ],
                            ) {
                                li {
                                    a {
                                        href is $spec->[0];
                                        title is $spec->[1];
                                        $spec->[2];
                                    };
                                };
                            }
                        };
                    }; # /div#mainMenu

                    # Content goes here!
                    $code->();

                }; # /div#content
            }; # /div#all

            # FOOTER: Site footer for links, copyright, etc.
            div {
                id is 'footer';
                div {
                    id is 'width';
                    span {
                        class is 'floatLeft';
                        outs 'code';
                        a {
                            href is 'http://www.justatheory.com/';
                            title is 'Go to Just a Theory';
                            'theory';
                        };
                        span { class is 'grey'; '|' };
                        outs ' design';
                        a {
                            href is 'http://fullahead.org/';
                            title is 'Go to Fullahead';
                            'Fullahead';
                        };
                        span { class is 'grey'; '|' };
                        outs ' logo';
                        a {
                            href is 'http://www.strongrrl.com/';
                            title is 'Go to Strongrrl';
                            'Strongrrl';
                        };
                    }; # /span.floatLeft
                    span {
                        class is 'floatRight';
                        a {
                            href is '#'; # XXX
                            title is 'Feedback';
                            'Feedback';
                        };
                    }; # /span.floatRight
                }; # /div#width
            }; # /div#footer
        }; # /body
    }; # /html
}; }


template home => sub {
    my ($self, $req, $args) = @_;
    wrapper {
        div {
            id is 'homepage';
            div {
                class is 'hsearch floatLeft';
                form {
                    id is 'homesearch';
                    action is '#'; # XXX
                    enctype is 'application/x-www-form-urlencoded; charset=UTF-8';
                    method is 'get';
                    fieldset {
                        input {
                            type  is 'text';
                            class is 'width50';
                            name  is 'q';
                        };
                    }; # /fieldset
                    fieldset {
                        label { attr { id is 'inlabel'; for => 'searchin' }; 'in' };
                        select {
                            id is 'searchin';
                            name is 'in';
                            option {
                                value is '';
                                selected is 'selected';
                                'All';
                            };
                            for my $doctype (qw(extensions distributions owners tags)) {
                                option {
                                    value is $doctype;
                                    ucfirst $doctype;
                                };
                            }
                        };
                        input {
                            type  is 'submit';
                            value is 'PGXN Search';
                            class is 'button';
                        };
                    }; # /fieldset
                }; # /form#homesearch

                div {
                    id is 'cloud';
                    # XXX Put tag cloud here.
                };
            }; # /div.hsearch floatLeft

            # 25 percent width column, aligned to the right.
            div {
                class is 'hside floatLeft gradient';
                p { 'PGXN, the PostgreSQL Extension network, is a central distribution
          system for open-source PostgreSQL extension libraries.' };

                h3 { 'Founders' };
                div {
                    id is 'founders';
                    a {
                        href is 'http://www.myyearbook.com/';
                        title is 'myYearbook';
                        img {
                            src is '/ui/img/myyearbook.png';
                            alt is 'myYearbook.com';
                        };
                    };
                    a {
                        href is 'http://www.pgexperts.com/';
                        title is 'PostgreSQL Experts, Inc.';
                        img {
                            src is '/ui/img/pgexperts.png';
                            alt is 'PGX';
                        };
                    };
                    a {
                        href is 'http://www.dalibo.org/en/';
                        title is 'Dalibo';
                        img {
                            src is '/ui/img/dalibo.png';
                            alt is 'Dalibo';
                        };
                    };
                }; # /div#founders

                h3 { 'Patrons' };
                div {
                    id is 'patrons';
                    h3 {
                        a {
                            href is 'http://www.enovafinancial.com/';
                            title is 'Enova Financial';
                            img {
                                src is '/ui/img/enova.png';
                                alt is 'e';
                            };
                            outs ' Enova Financial';
                        };
                    };
                }; # /div#patrons

                h3 { 'Benefactors' };
                ul {
                    for my $spec (
                        [ 'http://www.etsy.com/'          => 'Etsy'                      ],
                        [ 'http://www.postgresql.us/'     => 'US PostgreSQL Association' ],
                        [ 'http://www.commandprompt.com/' => 'Command Prompt, Inc.'      ],
                        [ 'http://www.marchex.com/'       => 'Marchex'                   ],
                    ) {
                        li { a { href is $spec->[0]; $spec->[1] } };
                    }
                }; # /ul
            }; # /div.hside floatLeft gradient

        }; # /div#homepage
    } $req, $args;
};

