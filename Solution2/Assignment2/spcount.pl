#!/usr/bin/perl
use LWP::Simple;
#swissprot stores the list of all protein entries, is then splitted to an array whose length is measured- same procedure for TREMBl
$bar = $ARGV[0];
@par = split(/ /,$bar);
my $lines = 0;
my $swissprot = get("http://www.uniprot.org/uniprot/?query=reviewed%3ayes+$par[0]+$par[1]+$par[2]+$par[3]&format=list");
@foo = split(/\n/, $swissprot);
$lines = @foo;
print "Zum Organismus existieren $lines Eintraege im Swissprot \n";
my $lines2 = 0;
my $embl = get("http://www.uniprot.org/uniprot/?query=reviewed%3Ano+$par[0]+$par[1]+$par[2]+$par[3]&format=list");
@foo = split(/\n/, $embl);
$lines2 = @foo;
print "Zum Organismus existieren $lines2 Eintraege im TREMBL";

