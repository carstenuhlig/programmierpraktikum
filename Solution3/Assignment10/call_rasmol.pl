#!/usr/bin/perl
use LWP::Simple;
#Laden einer bestimmten Datei von der online-Datenbank dem entsprechenden PDB-ID
my $FILE = get("http://www.rcsb.org/pdb/files/$ARGV[0].pdb");
#und speichern deren als .txt-Datei mit dem PDB-ID als Name der Datei
open (FH,">PDB.pdb");
print FH $FILE;
#Erstellen eines RasMol-Scripts mit einer cartoon-Einstellung.
my $SCRIPT = 'zap\nload pdb "PDB.pdb"'."\nselect all\ncartoon on\nselect all\nwireframe off";
#Die Datei wird dem PDB-ID entsprechend benannt.
open (FH,">PDB.spt");
print FH $SCRIPT;
close (FH);
#Es wird das Programm RasMol aufgerufen, das die Datenbank-Datei mit dem voreingestellten Script (wegen cartoon-view) öffnen muss. Beide Dateien werden dem PDB-ID entsprechend genannt.
my $status;
$status = system ("rasmol PDB.pdb -script PDB.spt");
#Die Datenbank- und Script-Dateien werden nach ausführen des Programms gelöscht
my $result = unlink ("PDB.pdb");
my $result = unlink ("PDB.spt");

