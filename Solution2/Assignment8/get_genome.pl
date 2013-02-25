#!/usr/bin/perl

use LWP::Simple;
use Net::FTP;
#we cannot connect directly to a given adress, because the position on the server can not be told by the organism's name only. therefore we scan the direction in which the files are stored and find out in which file's name the searched organism's name appears. then we connect to that file.
$organism = $ARGV[0];
$organism =~ s/\ /_/g;
$ftp = Net::FTP->new("ftp.ncbi.nlm.nih.gov", Passive => 1) or die "Cannot connect";
$ftp->login("anonymous");
@sourcecode = ($ftp -> dir("/genomes/Bacteria"));
$i = 0;
$found = 0;
while($found == 0){
if($sourcecode[$i] =~ m/($organism.*)/){
$found = 1;
$pos = $i;
$wholeOrganism = $1;
}
else{
$i++;
}
}
#here we define a subroutine for a task similar to that at the top. this time we must only scan by file ending.
sub findname{
@sourcecode = ($ftp -> dir("/genomes/Bacteria/$wholeOrganism"));
my $par = shift;
$i = 0;
$found = 0;
while($found == 0){
if($sourcecode[$i] =~ m/([^\ ]*\.$par)/){
$found = 1;
$pos = $i;
$returned = $1;
return($returned);
}
else{
$i++;
}
}
}
#downloads files and stores them.
$orfpredname = findname("5m");
print $orfpredname;
$ftp -> get ("genomes/Bacteria/$wholeOrganism/$orfpredname", "ORFs.txt") or die "ORF";
$genesname = findname("fna");
$ftp -> get ("genomes/Bacteria/$wholeOrganism/$genesname", "Genomes.txt") or die "Gen";
$protname = findname("faa");
$ftp -> get ("genomes/Bacteria/$wholeOrganism/$protname", "Proteins.txt") or die "Prot";

