#!/usr/bin/perl
use LWP::Simple;
#Laden einer bestimmten Datei von der online-Datenbank dem entsprechenden PDB-ID
my $FILE = get("http://www.rcsb.org/pdb/files/$ARGV[0].pdb");
#und speichern deren als .txt-Datei mit dem PDB-ID als Name der Datei
#open (FH,">PDB.txt");
print $FILE;
#close (FH);
