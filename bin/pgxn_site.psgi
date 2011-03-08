#!/usr/bin/env perl

use 5.12.0;
use utf8;
use lib 'lib';
use PGXN::Site::Router;

unless (@ARGV > 1) {
    say STDERR "\n  Usage: $ARGV[0] api_url [proxy_url]\n";
    exit 1;
}

PGXN::Site::Router->app(
    url   => $ARGV[1],
    proxy => $ARGV[2],
);
