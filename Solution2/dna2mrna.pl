#!/usr/bin/perl
use LWP::Simple;
$mrna = $ARGV[0];
$mrna =~ s/T/U/g;
$output = $mrna;
print $output;
