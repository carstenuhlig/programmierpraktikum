#!/usr/bin/perl
use LWP::Simple;
use Net::FTP;

# first we connect to the ftp server, log in and create our file prokaryotes.txt which contains the prokaryotes file from the NCBI and store it in the filehandler.
$ftp = Net::FTP->new("ftp.ncbi.nlm.nih.gov", Passive => 1) or die "Cannot connect";
$ftp->login("anonymous");
$ftp->get('/genomes/GENOME_REPORTS/prokaryotes.txt', "prokaryotes.txt") or die "no file";
open(fh, "prokaryotes.txt");
unlink("prokaryotes.txt");
my $organism = $ARGV[0];
my @gdat = <fh>;
$lengdat = @gdat;
my $pos = 0;
my $i = 0;
my $found = 0;
# in this loop we determine in which the organism name is found and then store that line as list. in the list we take element 5 which is the genome size in megabases.
while($found == 0){
if($gdat[$i] =~ m/$organism/){
$found = 1;
$pos = $i;
}
else{
$i++;
}
}

my @line = split(/\t/, $gdat[$i]);
my $len = $line[5];

print "Das Genom des Organismus $organism ist $len Megabasen lang.\n"
