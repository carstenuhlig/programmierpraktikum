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
select VAL1.CA
label VAL1.CA
select VAL1.CB
label VAL1.CB
select GLN152.CB
label GLN152.CB
select GLY153.CA
label GLY153.CA
color label orange
set fontsize 8

#Die Helizes [rot-magenta --> 255,0,128], die Turns [hellblau --> 96,128,255] und die restlichen Elemente [weiss --> 255,255,255], die in der PDB-Datei dargestellt werden:
select (atomno>=1) and (atomno<=21)
colour atoms [255,255,255]
select (atomno>=22) and (atomno<=141)
colour atoms [255,0,128]
select (atomno>=142) and (atomno<=155)
colour atoms [96,128,255]
select (atomno>=156) and (atomno<=163)
colour atoms [255,255,255]
select (atomno>=164) and (atomno<=279)
colour atoms [255,0,128]
select (atomno>=280) and (atomno<=289)
colour atoms [255,255,255]
select (atomno>=290) and (atomno<=329)
colour atoms [255,0,128]
select (atomno>=330) and (atomno<=338)
colour atoms [96,128,255]
select (atomno>=339) and (atomno<=349)
colour atoms [255,255,255]
select (atomno>=350) and (atomno<=388)
colour atoms [255,0,128]
select (atomno>=389) and (atomno<=398)
colour atoms [96,128,255]
select (atomno>=399) and (atomno<=422)
colour atoms [255,255,255]
select (atomno>=423) and (atomno<=467)
colour atoms [255,0,128]
select (atomno>=468) and (atomno<=473)
colour atoms [255,255,255]
select (atomno>=474) and (atomno<=604)
colour atoms [255,0,128]
select (atomno>=605) and (atomno<=608)
colour atoms [255,255,255]
select (atomno>=609) and (atomno<=635)
colour atoms [96,128,255]
select (atomno>=636) and (atomno<=655)
colour atoms [255,255,255]
select (atomno>=656) and (atomno<=752)
colour atoms [255,0,128]
select (atomno>=753) and (atomno<=771)
colour atoms [96,128,255]
select (atomno>=772) and (atomno<=795)
colour atoms [255,255,255]
select (atomno>=796) and (atomno<=948)
colour atoms [255,0,128]
select (atomno>=949) and (atomno<=958)
colour atoms [255,255,255]
select (atomno>=959) and (atomno<=988)
colour atoms [96,128,255]
select (atomno>=989) and (atomno<=992)
colour atoms [255,255,255]
select (atomno>=993) and (atomno<=1187)
colour atoms [255,0,128]
select (atomno>=1188) and (atomno<=1191)
colour atoms [96,128,255]
select (atomno>=1192) and (atomno<=1261)
colour atoms [255,255,255]

#Die C-alpha und -beta Atomen, die sich am einen und am anderen Ende der Kette befinden:
select atomno=2
colour atoms cpk
spacefill on
select atomno=5
colour atoms cpk
spacefill on
select atomno=1208
colour atoms cpk
spacefill on
select atomno=1214
colour atoms cpk
spacefill on
spacefill off

#Bindung zwischen den obigen C-alpha und -beta Atomen zeichnen:
select all
wireframe off
select (atomno=5) or (atomno==1208)
wireframe dash
select (atomno=2) or (atomno==1214)
wireframe dash
wireframe off

#Bindung zwischen den Molekülen mit minimalen x-, y- und z-Werten (Damit man die Koordinaten der Box erfaehrt).
select (atomno=329) or (atomno==65)
wireframe on
select (atomno=997) or (atomno==761)
wireframe on
select (atomno=1170) or (atomno==436)
wireframe on

#Die Distanz zwischen den obigen C-alpha und -beta Atomen zeigen.
set monitors on
monitor 2 1214
monitor 5 1208

#Die Distanz zwischen den Molekülen mit minimalen x-, y- und z-Werten. Wenn man sie zusammen multipliziert, bekommt man das Volumen der (gezeichneten) kleinsten Box, in der das Protein hineinpassen würde (boundingbox ganz oben).
monitor 329 65
monitor 997 761
monitor 1170 436";
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

