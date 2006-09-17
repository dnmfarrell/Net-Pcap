#!/usr/bin/perl -w
#
# Test for memory leaks in dispatch() function.
#
# $Id: leaktest3.pl,v 1.3 1999/05/05 02:11:59 tpot Exp $
#

use strict;
use English;

use ExtUtils::testlib;
use Net::Pcap;

die("Must run as root!\n"), if ($UID != 0);

my($dev, $err, $pcap_t);

$dev = Net::Pcap::lookupdev(\$err);
$pcap_t = Net::Pcap::open_live($dev, 1024, 1, 0, \$err);

if (!defined($pcap_t)) {
    die("Net::Pcap::open_live returned error $err");
}

my $count;

sub process_pkt {
    my($user, $hdr, $pkt) = @_;

    $count++;

    print("$count\n"), if (($count % 1000) == 0);
}

while(1) {
  Net::Pcap::dispatch($pcap_t, 0, \&process_pkt, "1234");
}

Net::Pcap::close($pcap_t);
