#!/usr/bin/perl
use LWP::Simple;
# T are replaced by U
$mrna = $ARGV[0];
$mrna =~ s/T/U/g;
$output = $mrna;
print $output;
