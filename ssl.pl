#!/usr/bin/perl
use strict;
use warnings;
use LWP::UserAgent;
use HTTP::Request::Common qw(GET);
use Net::SSL;

#my $ua = LWP::UserAgent->new();
#my $req = GET 'https://10.1.43.28:4343';
#my $res = $ua->request($req);
#if ($res->is_success) {
#    print $res->content;
#} else {
#    print $res->status_line . "\n";
#    print $res->content;
#}

use IO::Socket::SSL;

    # simple client
my $cl = IO::Socket::SSL->new('10.1.43.28:4343');
print $cl "GET / HTTP/1.0\r\n\r\n";
print <$cl>;
                