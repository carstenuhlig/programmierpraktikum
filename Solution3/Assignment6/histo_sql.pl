#!/usr/bin/perl -w
use strict;
use Getopt::Std;

my %opt = ();
getopts("m:M:c:",\%opt);

my $lowerbound;
if(defined $opt{m}){
  $lowerbound = $opt{m};
}
else{
  print "-m 'lower bound is missing.'\n";
  exit;
}

my $upperbound;
if(defined $opt{M}){
  $upperbound = $opt{M};
}
else{
  print "-M 'upper bound is missing.'\n";
  exit;
}

my $numint;
if(defined $opt{c}){
  $numint = $opt{c};
}
else{
  print "-c 'number of intervals is missing.'\n";
  exit;
}

print "Enter additional WHERE-clause: ";
my $cond = <STDIN>;
chomp $cond;
if($cond ne ""){
  $cond = "AND ".$cond;
}

my $distint = ($upperbound - $lowerbound)/$numint;
my $interval = "$lowerbound, $upperbound"; 
my $intervals = $lowerbound;
for(my $i = 1; $i < $numint; $i++){
  $intervals.= ", ".($lowerbound + $i * $distint);
}
$intervals.= ", ".$upperbound;

print "SELECT \($lowerbound + $distint *\(-1 + INTERVAL\(LENGTH\(sequence\), $intervals\)\)\) \"length\", COUNT(*) \"number\" FROM sequences WHERE \(INTERVAL\(LENGTH\(sequence\), $interval\)\) \= 1 $cond GROUP BY INTERVAL\(LENGTH\(sequence\), $intervals\)\n";
