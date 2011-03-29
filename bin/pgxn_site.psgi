#!/usr/bin/env perl

use 5.12.0;
use utf8;
use lib 'lib';
use PGXN::Site::Router;

my $self = shift;
unless (@ARGV >= 8) {
    say STDERR "\n  Usage: $self \\
                            errors_to alert\@example.com \\
                            errors_from pgxn-site\@example.com \\
                            api_url \$api_url \\
                            mirror_url \$mirror_url \\
                            [proxy_url \$proxy_url]\n";
    exit 1;
}

PGXN::Site::Router->app(@ARGV);
