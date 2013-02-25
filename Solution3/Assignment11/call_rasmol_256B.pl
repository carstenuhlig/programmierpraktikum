#!/usr/bin/perl
use LWP::Simple;
#Laden einer bestimmten Datei von der online-Datenbank dem entsprechenden PDB-ID
my $FILE = get("http://www.rcsb.org/pdb/files/$ARGV[0].pdb");
#und speichern deren als .txt-Datei mit dem PDB-ID als Name der Datei
open (FH,">PDB.pdb");
print FH $FILE;
#Erstellen eines RasMol-Scripts mit den ensprechenden Einstellungen (fuer die einzelnen Beschreibungen, siehe die unteren Kommentare).
my $SCRIPT = 'zap\nload pdb "PDB.pdb"'."\nselect all\ncartoon on\nselect all\nwireframe off

#Die kleinste Box, in der das Protein hineinpassen würde:
set boundingbox on

#Labeling:
select ALA1A.CA
label ALA1A.CA
select ALA1A.CB
label ALA1A.CB
select ARG106A.CA
label ARG106A.CA
select ARG106A.CB
label ARG106A.CB
select ALA1B.CA
label ALA1B.CA
select ALA1B.CB
label ALA1B.CB
select ARG106B.CA
label ARG106B.CA
select ARG106B.CB
label ARG106B.CB
color label yellow
set fontsize 8

#Structure coloring
select (atomno>=1) and (atomno<=13)
colour atoms [255,255,255]
select (atomno>=14) and (atomno<=152)
colour atoms [255,0,128]
select (atomno>=153) and (atomno<=173)
colour atoms [255,255,255]
select (atomno>=174) and (atomno<=300)
colour atoms [255,0,128]
select (atomno>=301) and (atomno<=337)
colour atoms [255,255,255]
select (atomno>=338) and (atomno<=361)
colour atoms [255,0,128]
select (atomno>=362) and (atomno<=414)
colour atoms [255,255,255]
select (atomno>=415) and (atomno<=613)
colour atoms [255,0,128]
select (atomno>=614) and (atomno<=635)
colour atoms [255,255,255]
select (atomno>=636) and (atomno<=814)
colour atoms [255,0,128]
select (atomno>=815) and (atomno<=840)
colour atoms [255,255,255]
select (atomno>=841) and (atomno<=979)
colour atoms [255,0,128]
select (atomno>=980) and (atomno<=1000)
colour atoms [255,255,255]
select (atomno>=1001) and (atomno<=1127)
colour atoms [255,0,128]
select (atomno>=1128) and (atomno<=1164)
colour atoms [255,255,255]
select (atomno>=1165) and (atomno<=1188)
colour atoms [255,0,128]
select (atomno>=1189) and (atomno<=1241)
colour atoms [255,255,255]
select (atomno>=1242) and (atomno<=1440)
colour atoms [255,0,128]
select (atomno>=1441) and (atomno<=1462)
colour atoms [255,255,255]
select (atomno>=1463) and (atomno<=1641)
colour atoms [255,0,128]
select (atomno>=1642) and (atomno<=1925)
colour atoms [255,255,255]
select all
spacefill off

#Die C-alpha und -beta Atomen, die sich am einen und am anderen Ende der Kette A befinden:
select atomno=2
colour atoms cpk
spacefill on
select atomno=5
colour atoms cpk
spacefill on
select atomno=816
colour atoms cpk
spacefill on
select atomno=819
colour atoms cpk
spacefill on

#Die C-alpha und -beta Atomen, die sich am einen und am anderen Ende der Kette B befinden:
select atomno=829
colour atoms cpk
spacefill on
select atomno=832
colour atoms cpk
spacefill on
select atomno=1643
colour atoms cpk
spacefill on
select atomno=1646
colour atoms cpk
spacefill on
spacefill off

#Bindung zwischen den obigen C-alpha und -beta Atomen zeichnen:
select all
wireframe off
select (atomno=5) or (atomno==819)
wireframe dash
select (atomno=2) or (atomno==816)
wireframe dash
select (atomno=829) or (atomno==1643)
wireframe dash
select (atomno=832) or (atomno==1646)
wireframe off

#Bindung zwischen den Molekülen mit minimalen x-, y- und z-Werten (Damit man die Koordinaten der Box erfaehrt).
select (atomno=591) or (atomno==1234)
wireframe on
select (atomno=1010) or (atomno==216)
wireframe on
select (atomno=392) or (atomno==651)
wireframe on

#Die Distanz zwischen den obigen C-alpha und -beta Atomen zeigen.
set monitors on
monitor 2 816
monitor 5 819
monitor 829 1643
monitor 832 1646

#Die Distanz zwischen den Molekülen mit minimalen x-, y- und z-Werten. Wenn man sie zusammen multipliziert, bekommt man das Volumen der (gezeichneten) kleinsten Box, in der #das Protein hineinpassen würde (boundingbox ganz oben).
monitor 591 1234
monitor 1010 216
monitor 392 651";

#Die Datei wird dem PDB-ID entsprechend benannt.
open (FH,">PDB.spt");
print FH $SCRIPT;
close (FH);
#Es wird das Programm RasMol aufgerufen, das die Datenbank-Datei mit dem voreingestellten Script (wegen den einzelnen Einstellungen) öffnen muss. Beide Dateien werden dem PDB-ID entsprechend genannt.
my $status;
$status = system ("rasmol PDB.pdb -script PDB.spt");
#Die Datenbank- und Script-Dateien werden nach ausführen des Programms gelöscht
my $result = unlink ("PDB.pdb");
my $result = unlink ("PDB.spt");

