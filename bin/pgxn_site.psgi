#!/usr/bin/env perl

use 5.12.0;
use utf8;
use lib 'lib';
use PGXN::Site::Router;

my $self = shift;
unless (@ARGV >= 4) {
    say STDERR "\n  Usage: $self api_url \$api_url \\
                            mirror_url \$mirror_url \\
                            [proxy_url \$proxy_url]\n";
    exit 1;
}

PGXN::Site::Router->app(@ARGV);
