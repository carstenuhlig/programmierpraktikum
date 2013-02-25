#!/usr/bin/perl -w
use strict;
use DBI;

#connect to database
my $dbh = DBI->connect("DBI:mysql:bioprakt6:mysql2-ext.bio.ifi.lmu.de", "bioprakt6", "JzJyggflWG") or die "Error connecting to database.";

#prepare query
my $seq_query = $dbh->prepare('SELECT accession_nr.accession FROM sequences, keywords, accession_nr WHERE sequences.id = keywords.fromseq AND sequences.id = accession_nr.fromseq AND keywords.keyword = ?');

$seq_query->execute($ARGV[0]);

#print results
while (my @row = $seq_query->fetchrow_array()) {
  print $row[0]."\n";
}

#dissconnect from database
$dbh->disconnect;

