#!/usr/bin/perl -w
use strict;
use DBI;
#Inserts all Fasta Sequences in Input file into the Database for test reasons
my $filename = $ARGV[0];
open(FH, $filename);
my $fasta = join("", <FH>);
$fasta =~ s/\>gi.+\n//;
my @genes = split(/\>gi.*?\n/, $fasta);

my $dbh = DBI->connect("DBI:mysql:bioprakt6:mysql2-ext.bio.ifi.lmu.de", "bioprakt6", "JzJyggflWG") or die "Error connecting to database.";

for(my $i = 0; $i <= $#genes; $i++){
  $genes[$i] =~ s/\n//g;
  my $seq_query = $dbh->prepare("INSERT INTO sequences \(sequence, organism\) VALUES \(\'$genes[$i]\', \'Unknown\'\)");
  $seq_query->execute();
}
$dbh->disconnect;


