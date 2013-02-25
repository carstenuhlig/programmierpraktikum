#!/usr/bin/perl
use LWP::Simple;
open(fh, $ARGV[0]);
$seq = join("", <fh>);
$seq =~ s/>.*\n//;
$query = <STDIN>;
$seq =~ s/N//g;
$seq =~ s/\n//g;
my $occ = 0;
#remove \n from STDIN"
chomp $query;
while($seq =~ m/$query/g){
++$occ;
}
print ("Sequenzstueck kommt $occ mal vor\n");
