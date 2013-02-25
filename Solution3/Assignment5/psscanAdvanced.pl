#!/usr/bin/perl -w
use strict;

use Getopt::Std;
use LWP::Simple;


my $regex = $ARGV[0];
#eliminate -
$regex =~ s/-//g;
#change x to .
$regex =~ s/x/./g; #[ARNDBCEQZGHILKMFPSTWYV]
#change {xyz} to [^xyz]
$regex =~ s/\{(.+)\}/\[^$1\]/g;
#change (d) to {d}
$regex =~ s/\(([\d|,]*)\)/\{$1\}/g;
my $filename = $ARGV[1];
open(FH, $filename);
my $fasta = join("", <FH>);
$fasta =~ s/\>gi.+?\n//;
my @genes = split(/\>gi.+\n/, $fasta);
for(my $i = 0; $i <= $#genes; $i++){
  $genes[$i] =~ s/[^ATCG]//g;
  if($genes[$i] =~ m/$regex/){
    print $i."\n";
  }
}

