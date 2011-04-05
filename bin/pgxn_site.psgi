#!/usr/bin/env perl

use 5.12.0;
use utf8;
use blib;
use PGXN::Site::Router;

my $self = shift;

my @args;
while (my $v = shift @ARGV) {
    push @args, $v => shift @ARGV if $v ~~ [qw(
        errors_to
        errors_from
        feedback_to
        private_api_url
        api_url proxy_url
        reverse_proxy
    )];
}

unless (@args >= 8) {
    say STDERR "\n  Usage: $self \\
         errors_to alert\@example.com \\
         errors_from pgxn-site\@example.com \\
         feeback_to pgxn-feedback\@example.com \\
         api_url \$api_url \\
         [reverse_proxy 1] \\
         [private_api_url \$private_api_url] \\
         [proxy_url \$proxy_url]\n";
    exit 1;
}

PGXN::Site::Router->app(@args);
