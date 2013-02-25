#!/usr/bin/perl
use LWP::Simple;
#we print the file as standardout
print STDOUT get("http://www.uniprot.org/uniprot/$ARGV[0].fasta");


