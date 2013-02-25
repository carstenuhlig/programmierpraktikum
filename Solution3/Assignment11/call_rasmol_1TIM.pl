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
select HIS248A.CA
label HIS248A.CA
select HIS248A.CB
label HIS248A.CB
select ALA1B.CA
label ALA1B.CA
select ALA1B.CB
label ALA1B.CB
select HIS248B.CA
label HIS248B.CA
select HIS248B.CB
label HIS248B.CB
color label greenblue
set fontsize 8

#Structure coloring
select (atomno>=1) and (atomno<=32)
colour atoms [255,255,255]
select (atomno>=33) and (atomno<=91)
colour atoms [255,200,0]
select (atomno>=92) and (atomno<=120)
colour atoms [255,255,255]
select (atomno>=121) and (atomno<=234)
colour atoms [255,0,128]
select (atomno>=235) and (atomno<=262)
colour atoms [255,255,255]
select (atomno>=263) and (atomno<=310)
colour atoms [255,200,0]
select (atomno>=311) and (atomno<=315)
colour atoms [255,255,255]
select (atomno>=316) and (atomno<=417)
colour atoms [255,0,128]
select (atomno>=418) and (atomno<=447)
colour atoms [255,255,255]
select (atomno>=448) and (atomno<=468)
colour atoms [255,200,0]
select (atomno>=469) and (atomno<=583)
colour atoms [255,255,255]
select (atomno>=584) and (atomno<=646)
colour atoms [255,0,128]
select (atomno>=647) and (atomno<=651)
colour atoms [255,255,255]
select (atomno>=652) and (atomno<=693)
colour atoms [255,200,0]
select (atomno>=694) and (atomno<=697)
colour atoms [255,255,255]
select (atomno>=698) and (atomno<=772)
colour atoms [255,0,128]
select (atomno>=773) and (atomno<=785)
colour atoms [255,255,255]
select (atomno>=786) and (atomno<=899)
colour atoms [255,0,128]
select (atomno>=900) and (atomno<=907)
colour atoms [255,255,255]
select (atomno>=908) and (atomno<=958)
colour atoms [255,200,0]
select (atomno>=959) and (atomno<=1154)
colour atoms [255,0,128]
select (atomno>=1155) and (atomno<=1191)
colour atoms [255,255,255]
select (atomno>=1192) and (atomno<=1262)
colour atoms [255,200,0]
select (atomno>=1263) and (atomno<=1325)
colour atoms [255,255,255]
select (atomno>=1326) and (atomno<=1546)
colour atoms [255,0,128]
select (atomno>=1547) and (atomno<=1589)
colour atoms [255,200,0]
select (atomno>=1590) and (atomno<=1606)
colour atoms [255,255,255]
select (atomno>=1607) and (atomno<=1681)
colour atoms [255,0,128]
select (atomno>=1682) and (atomno<=1706)
colour atoms [255,255,255]
select (atomno>=1707) and (atomno<=1744)
colour atoms [255,200,0]
select (atomno>=1745) and (atomno<=1851)
colour atoms [255,0,128]
select (atomno>=1852) and (atomno<=1903)
colour atoms [255,255,255]
select (atomno>=1904) and (atomno<=1962)
colour atoms [255,200,0]
select (atomno>=1963) and (atomno<=1991)
colour atoms [255,255,255]
select (atomno>=1992) and (atomno<=2105)
colour atoms [255,0,128]
select (atomno>=2106) and (atomno<=2133)
colour atoms [255,255,255]
select (atomno>=2134) and (atomno<=2181)
colour atoms [255,200,0]
select (atomno>=2182) and (atomno<=2186)
colour atoms [255,255,255]
select (atomno>=2187) and (atomno<=2288)
colour atoms [255,0,128]
select (atomno>=2289) and (atomno<=2318)
colour atoms [255,255,255]
select (atomno>=2319) and (atomno<=2339)
colour atoms [255,200,0]
select (atomno>=2340) and (atomno<=2454)
colour atoms [255,255,255]
select (atomno>=2455) and (atomno<=2517)
colour atoms [255,0,128]
select (atomno>=2518) and (atomno<=2522)
colour atoms [255,255,255]
select (atomno>=2523) and (atomno<=2564)
colour atoms [255,200,0]
select (atomno>=2565) and (atomno<=2568)
colour atoms [255,255,255]
select (atomno>=2569) and (atomno<=2643)
colour atoms [255,0,128]
select (atomno>=2644) and (atomno<=2656)
colour atoms [255,255,255]
select (atomno>=2657) and (atomno<=2770)
colour atoms [255,0,128]
select (atomno>=2771) and (atomno<=2778)
colour atoms [255,255,255]
select (atomno>=2779) and (atomno<=2829)
colour atoms [255,200,0]
select (atomno>=2830) and (atomno<=3025)
colour atoms [255,0,128]
select (atomno>=3026) and (atomno<=3062)
colour atoms [255,255,255]
select (atomno>=3063) and (atomno<=3133)
colour atoms [255,200,0]
select (atomno>=3134) and (atomno<=3196)
colour atoms [255,255,255]
select (atomno>=3197) and (atomno<=3417)
colour atoms [255,0,128]
select (atomno>=3418) and (atomno<=3460)
colour atoms [255,200,0]
select (atomno>=3461) and (atomno<=3477)
colour atoms [255,255,255]
select (atomno>=3478) and (atomno<=3552)
colour atoms [255,0,128]
select (atomno>=3553) and (atomno<=3577)
colour atoms [255,255,255]
select (atomno>=3578) and (atomno<=3615)
colour atoms [255,200,0]
select (atomno>=3616) and (atomno<=3722)
colour atoms [255,0,128]
select (atomno>=3723) and (atomno<=3741)
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
select atomno=1862
colour atoms cpk
spacefill on
select atomno=1865
colour atoms cpk
spacefill on
#Die C-alpha und -beta Atomen, die sich am einen und am anderen Ende der Kette B befinden:
select atomno=1873
colour atoms cpk
spacefill on
select atomno=1876
colour atoms cpk
spacefill on
select atomno=3733
colour atoms cpk
spacefill on
select atomno=3736
colour atoms cpk
spacefill on
spacefill off

#Bindung zwischen den obigen C-alpha und -beta Atomen zeichnen:
select all
wireframe off
select (atomno=5) or (atomno==1865)
wireframe dash
select (atomno=2) or (atomno==1862)
wireframe dash
select (atomno=1876) or (atomno==3736)
wireframe dash
select (atomno=1873) or (atomno==3733)
wireframe off

#Bindung zwischen den Molekülen mit minimalen x-, y- und z-Werten (Damit man die Koordinaten der Box erfaehrt).
select (atomno=2887) or (atomno==200)
wireframe on
select (atomno=1691) or (atomno==3562)
wireframe on
select (atomno=2047) or (atomno==1312)
wireframe on

#Die Distanz zwischen den obigen C-alpha und -beta Atomen zeigen.
set monitors on
monitor 2 1862
monitor 5 1865
monitor 1876 3736
monitor 1873 3733

#Die Distanz zwischen den Molekülen mit minimalen x-, y- und z-Werten. Wenn man sie zusammen multipliziert, bekommt man das Volumen der (gezeichneten) kleinsten Box, in der #das Protein hineinpassen würde (boundingbox ganz oben).
monitor 2887 200
monitor 1691 3562
monitor 2047 1312";

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

