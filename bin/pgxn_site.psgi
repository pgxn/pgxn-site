#!/usr/bin/env perl

use 5.12.0;
use utf8;
use lib 'lib';
use PGXN::Site::Router;

my $self = shift;

my @args;
while (my $v = shift @ARGV) {
    push @args, $v => shift @ARGV
        if $v ~~ [qw(errors_to errors_from private_api_url api_url proxy_url)];
}

unless (@args >= 6) {
    say STDERR "\n  Usage: $self \\
         errors_to alert\@example.com \\
         errors_from pgxn-site\@example.com \\
         private_api_url \$private_api_url \\
         api_url \$api_url \\
         [proxy_url \$proxy_url]\n";
    exit 1;
}

PGXN::Site::Router->app(@args);
