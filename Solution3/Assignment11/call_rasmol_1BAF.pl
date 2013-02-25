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
select GLN1L.CA
label GLN1L.CA
select GLN1L.CB
label GLN1L.CB
select CYS214L.CA
label CYS214L.CA
select CYS214L.CB
label CYS214L.CB
select GLN1H.CA
label GLN1H.CA
select GLN1H.CB
label GLN1H.CB
select CYS214H.CA
label CYS214H.CA
select CYS214H.CB
label CYS214H.CB
color label greenblue
set fontsize 8

#Structure coloring
select (atomno>=1) and (atomno<=31)
colour atoms [255,255,255]
select (atomno>=32) and (atomno<=69)
colour atoms [255,200,0]
select (atomno>=70) and (atomno<=82)
colour atoms [255,255,255]
select (atomno>=83) and (atomno<=114)
colour atoms [255,200,0]
select (atomno>=115) and (atomno<=157)
colour atoms [255,255,255]
select (atomno>=158) and (atomno<=213)
colour atoms [255,200,0]
select (atomno>=214) and (atomno<=259)
colour atoms [255,255,255]
select (atomno>=260) and (atomno<=350)
colour atoms [255,200,0]
select (atomno>=351) and (atomno<=398)
colour atoms [255,255,255]
select (atomno>=399) and (atomno<=456)
colour atoms [255,200,0]
select (atomno>=457) and (atomno<=482)
colour atoms [255,255,255]
select (atomno>=483) and (atomno<=502)
colour atoms [255,200,0]
select (atomno>=503) and (atomno<=561)
colour atoms [255,255,255]
select (atomno>=562) and (atomno<=607)
colour atoms [255,200,0]
select (atomno>=608) and (atomno<=621)
colour atoms [255,255,255]
select (atomno>=622) and (atomno<=678)
colour atoms [255,200,0]
select (atomno>=679) and (atomno<=712)
colour atoms [255,255,255]
select (atomno>=713) and (atomno<=753)
colour atoms [255,0,128]
select (atomno>=754) and (atomno<=843)
colour atoms [255,200,0]
select (atomno>=844) and (atomno<=896)
colour atoms [255,255,255]
select (atomno>=897) and (atomno<=917)
colour atoms [255,200,0]
select (atomno>=918) and (atomno<=935)
colour atoms [255,255,255]
select (atomno>=936) and (atomno<=985)
colour atoms [255,200,0]
select (atomno>=986) and (atomno<=1049)
colour atoms [255,255,255]
select (atomno>=1050) and (atomno<=1095)
colour atoms [255,200,0]
select (atomno>=1096) and (atomno<=1109)
colour atoms [255,255,255]
select (atomno>=1110) and (atomno<=1173)
colour atoms [255,0,128]
select (atomno>=1174) and (atomno<=1178)
colour atoms [255,255,255]
select (atomno>=1179) and (atomno<=1275)
colour atoms [255,200,0]
select (atomno>=1276) and (atomno<=1318)
colour atoms [255,255,255]
select (atomno>=1319) and (atomno<=1397)
colour atoms [255,200,0]
select (atomno>=1398) and (atomno<=1411)
colour atoms [255,255,255]
select (atomno>=1412) and (atomno<=1440)
colour atoms [255,200,0]
select (atomno>=1441) and (atomno<=1468)
colour atoms [255,255,255]
select (atomno>=1469) and (atomno<=1520)
colour atoms [255,200,0]
select (atomno>=1521) and (atomno<=1606)
colour atoms [255,255,255]
select (atomno>=1607) and (atomno<=1698)
colour atoms [255,200,0]
select (atomno>=1699) and (atomno<=1754)
colour atoms [255,0,128]
select (atomno>=1755) and (atomno<=1795)
colour atoms [255,255,255]
select (atomno>=1796) and (atomno<=1871)
colour atoms [255,200,0]
select (atomno>=1872) and (atomno<=1893)
colour atoms [255,255,255]
select (atomno>=1894) and (atomno<=1986)
colour atoms [255,200,0]
select (atomno>=1987) and (atomno<=2051)
colour atoms [255,255,255]
select (atomno>=2052) and (atomno<=2083)
colour atoms [255,200,0]
select (atomno>=2084) and (atomno<=2118)
colour atoms [255,255,255]
select (atomno>=2119) and (atomno<=2135)
colour atoms [255,200,0]
select (atomno>=2136) and (atomno<=2183)
colour atoms [255,255,255]
select (atomno>=2184) and (atomno<=2254)
colour atoms [255,200,0]
select (atomno>=2255) and (atomno<=2330)
colour atoms [255,255,255]
select (atomno>=2331) and (atomno<=2417)
colour atoms [255,200,0]
select (atomno>=2418) and (atomno<=2465)
colour atoms [255,255,255]
select (atomno>=2466) and (atomno<=2545)
colour atoms [255,200,0]
select (atomno>=2546) and (atomno<=2580)
colour atoms [255,255,255]
select (atomno>=2581) and (atomno<=2620)
colour atoms [255,200,0]
select (atomno>=2621) and (atomno<=2685)
colour atoms [255,255,255]
select (atomno>=2686) and (atomno<=2746)
colour atoms [255,200,0]
select (atomno>=2747) and (atomno<=2787)
colour atoms [255,255,255]
select (atomno>=2788) and (atomno<=2853)
colour atoms [255,200,0]
select (atomno>=2854) and (atomno<=2882)
colour atoms [255,255,255]
select (atomno>=2883) and (atomno<=2928)
colour atoms [255,0,128]
select (atomno>=2929) and (atomno<=2998)
colour atoms [255,200,0]
select (atomno>=2999) and (atomno<=3088)
colour atoms [255,255,255]
select (atomno>=3089) and (atomno<=3133)
colour atoms [255,200,0]
select (atomno>=3134) and (atomno<=3202)
colour atoms [255,255,255]
select (atomno>=3203) and (atomno<=3248)
colour atoms [255,200,0]
select (atomno>=3249) and (atomno<=3326)
colour atoms [255,255,255]
select (atomno>=3327) and (atomno<=3422)
colour atoms [255,200,0]
select (atomno>=3423) and (atomno<=3466)
colour atoms [255,255,255]
select (atomno>=3467) and (atomno<=3508)
colour atoms [255,200,0]
select (atomno>=3509) and (atomno<=3519)
colour atoms [255,255,255]
select (atomno>=3520) and (atomno<=3540)
colour atoms [255,0,128]
select (atomno>=3541) and (atomno<=3570)
colour atoms [255,255,255]
select (atomno>=3571) and (atomno<=3642)
colour atoms [255,200,0]
select (atomno>=3643) and (atomno<=3680)
colour atoms [255,255,255]
select (atomno>=3681) and (atomno<=3768)
colour atoms [255,200,0]
select (atomno>=3769) and (atomno<=3850)
colour atoms [255,255,255]
select (atomno>=3851) and (atomno<=3904)
colour atoms [255,200,0]
select (atomno>=3905) and (atomno<=3933)
colour atoms [255,255,255]
select (atomno>=3934) and (atomno<=3998)
colour atoms [255,200,0]
select (atomno>=3999) and (atomno<=4084)
colour atoms [255,255,255]
select all
spacefill off

#Die C-alpha und -beta Atomen, die sich am einen und am anderen Ende der Kette L befinden:
select atomno=2
colour atoms cpk
spacefill on
select atomno=5
colour atoms cpk
spacefill on
select atomno=2026
colour atoms cpk
spacefill on
select atomno=2029
colour atoms cpk
spacefill on

#Die C-alpha und -beta Atomen, die sich am einen und am anderen Ende der Kette H befinden:
select atomno=2034
colour atoms cpk
spacefill on
select atomno=2037
colour atoms cpk
spacefill on
select atomno=4050
colour atoms cpk
spacefill on
select atomno=4053
colour atoms cpk
spacefill on
spacefill off

#Bindung zwischen den obigen C-alpha und -beta Atomen zeichnen:
select all
wireframe off
select (atomno=5) or (atomno==2029)
wireframe dash
select (atomno=2) or (atomno==2026)
wireframe dash
select (atomno=2037) or (atomno==4053)
wireframe dash
select (atomno=2034) or (atomno==4050)
wireframe off

#Bindung zwischen den Molekülen mit minimalen x-, y- und z-Werten (Damit man die Koordinaten der Box erfaehrt).
select (atomno=1910) or (atomno==6775)
wireframe on
select (atomno=2008) or (atomno==273)
wireframe on
select (atomno=3831) or (atomno==2671)
wireframe on

#Die Distanz zwischen den obigen C-alpha und -beta Atomen zeigen.
set monitors on
monitor 2 2026
monitor 5 2029
monitor 2034 4050
monitor 2037 4053

#Die Distanz zwischen den Molekülen mit minimalen x-, y- und z-Werten. Wenn man sie zusammen multipliziert, bekommt man das Volumen der (gezeichneten) kleinsten Box, in der #das Protein hineinpassen würde (boundingbox ganz oben).
monitor 1910 6775
monitor 2008 273
monitor 3831 2671";

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

