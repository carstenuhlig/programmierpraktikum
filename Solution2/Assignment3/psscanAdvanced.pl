#!/usr/bin/perl -w
use strict;

use Getopt::Std;
use LWP::Simple;

my %opt = ();
getopts("ew:",\%opt);
my $regexOrig;
if(defined $opt{w}){
my $patternfile = get("http://prosite.expasy.org/$opt{w}.txt"); 
$patternfile =~ m/PA   (.*)\./;
$regexOrig = $1;
}
else {
$regexOrig = $ARGV[0];
}

sub getfasta{
  get("http://www.uniprot.org/uniprot/$_[0].fasta");
}

#eliminate -
my $regex = $regexOrig;
$regex =~ s/-//g;
#change x to .
$regex =~ s/x/./g; #[ARNDBCEQZGHILKMFPSTWYV]
#change {xyz} to [^xyz]
$regex =~ s/\{(.+)\}/\[^$1\]/g;
#change (d) to {d}
$regex =~ s/\(([\d|,]*)\)/\{$1\}/g;

print $regex;
my $filename = $ARGV[1];
open(FH, $filename);
my $fasta = join("", <FH>);
$fasta =~ s/\>gi.+\n//;
my @genes = split(/\>gi.+\n/, $fasta);
for(my $i = 0; $i < $#genes; $i++){
  $genes[$i] =~ s/\n//g;
  my $result = "";
    if($opt{e}) { 
	  use LWP::UserAgent; 
	  use HTTP::Request::Common qw{ POST };
	  my $url = "http://prosite.expasy.org/cgi-bin/prosite/PSScan.cgi";
	  my $ua     = LWP::UserAgent->new();
	  my $request = POST($url, [ 'seq' => $genes[$i] , 'sig' => $regexOrig, 'output'=>'txt'] );
	  $result = $ua->request($request)->content;
	  chomp $result;
  }
  else{
    $genes[$i] =~ s/>.*\n//;
    $genes[$i] =~ s/\n//g;
    if($genes[$i] =~ m/($regex)/){
      #my $endPos = pos $genes[$i];
      #my $startPos = $endPos - length($1) + 1;
      $result = $result.$i."\n"; #"\t".$startPos."\t".$1."\n";
    }
  }

  print "$result";
}
