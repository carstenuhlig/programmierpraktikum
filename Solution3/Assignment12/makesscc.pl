#!/usr/bin/perl -w
use strict;
use Getopt::Std;
use LWP::Simple;
#get parameters
my %opt = ();
getopts("f:d:t:l:",\%opt);

my $pdbid;
if(defined $opt{f}){
  $pdbid = $opt{f};
} 
else{
  print "PDB-ID missing.\n";
}

my $dist;
if(defined $opt{d}){
  $dist = $opt{d};
} 
else{
  print "contact distance missing\n";
}

my $satom;
 if(defined $opt{t}){
  $satom = $opt{t};
} 
else{
  print "kind of atom missing\n";
}

my $seqdist;
  if(defined $opt{l}){
  $seqdist = $opt{l};
} 
else{
  print "sequence distance missing\n";
}

my %oneLetter = ("ALA" , "A", "ARG" , "R" , "ASN" , "N", "ASP" , "D", "CYS" , "C", "GLU" , "E", "GLN" , "Q", "GLY", "G" , "HIS" , "H", "ILE" , "I", "LEU" , "L", "LYS" , "K", "MET" , "M", "PHE" , "F", "PRO" , "P", "SER" , "S", "THR" , "T", "TRP" , "W", "TYR" , "Y", "VAL" , "V");

#get pdb file
my $file = get("http://www.rcsb.org/pdb/files/$pdbid.pdb");
my @lines = split(/\n/, $file);

#open(FH, "test.pdb");
#my @lines = <FH>;
#read ATOM-lines from file and put into a hash of a hash
my %atoms;
my %sheets;
my %helices;
foreach my $line (@lines){		
  if($line =~ m/^ATOM\s+(\S+)\s+(\S+)\s+(\S+)\s+(\S+)\s+(\S+)\s+(\S+)\s+(\S+)\s+(\S+)/){
    my $null = "";
    for(my $i = 0; $i < (4 - length($5)); $i++){
      $null.= "0";
    }
    $atoms{$1} = {"type" => $2,  "aatype" => $oneLetter{$3}, "chain" => $4, "aaid" => $null.$5, "x" => $6, "y" => $7, "z" => $8}; 
  }
  if($line =~ m/^SHEET\s+(\S)+\s+(\S)+\s+\S+\s+\S+\s+(\S+)\s+(\S+)\s+\S+\s+\S+\s+(\S+)/){
    $sheets{$1.$2} = {"chain" => $3, "start" => $4,  "end" => $5}; 
  }
  if($line =~ m/^HELIX\s+(\S+)\s+\S+\s+\S+\s+(\S+)\s+(\S+)\s+\S+\s+\S+\s+(\S+)/){
    $helices{$1} = {"chain" => $2, "start" => $3,  "end" => $4}; 
  }
}    

#make up a hash of hash containing amino acids and their values
my %aminoacids;
my %matrix;
my %distances;
foreach my $atom (keys %atoms){
  $aminoacids{$atoms{$atom}{"chain"}.$atoms{$atom}{"aaid"}} = {"type" => $atoms{$atom}{"aatype"}, "chain" => $atoms{$atom}{"chain"}, "secondary" => "o", "local" => 0, "global" => 0};
}

foreach my $atom (keys %atoms){
  if($atoms{$atom}{"type"} eq $satom){
    foreach my $atom2 (keys %atoms){
      if($atoms{$atom2}{"type"} eq $satom && $atom < $atom2){
	my $x1 = $atoms{$atom}{"x"};
	my $y1 = $atoms{$atom}{"y"};
	my $z1 = $atoms{$atom}{"z"};
	my $x2 = $atoms{$atom2}{"x"};
	my $y2 = $atoms{$atom2}{"y"};
	my $z2 = $atoms{$atom2}{"z"};
#calculate distances
	my $cdist = sqrt(($x1-$x2)**2 + ($y1-$y2)**2 + ($z1-$z2)**2);
#save distances
	$distances{$atoms{$atom}{"chain"}.$atoms{$atom}{"aaid"}}{$atoms{$atom2}{"chain"}.$atoms{$atom2}{"aaid"}} = $cdist;
	$distances{$atoms{$atom2}{"chain"}.$atoms{$atom2}{"aaid"}}{$atoms{$atom}{"chain"}.$atoms{$atom}{"aaid"}} = $cdist;

	if($cdist < $dist){
#save contacts in contact matrix
	  $matrix{$atoms{$atom}{"chain"}.$atoms{$atom}{"aaid"}}{$atoms{$atom2}{"chain"}.$atoms{$atom2}{"aaid"}} = 1;
	  $matrix{$atoms{$atom2}{"chain"}.$atoms{$atom2}{"aaid"}}{$atoms{$atom}{"chain"}.$atoms{$atom}{"aaid"}} = 1;
#save local and global contacts
	  if($atoms{$atom}{"chain"} eq $atoms{$atom2}{"chain"} && abs($atoms{$atom}{"aaid"} - $atoms{$atom2}{"aaid"}) < $seqdist){
	    $aminoacids{$atoms{$atom}{"chain"}.$atoms{$atom}{"aaid"}}{"local"}++;
	    $aminoacids{$atoms{$atom2}{"chain"}.$atoms{$atom2}{"aaid"}}{"local"}++;
	  }
	  else{
	    $aminoacids{$atoms{$atom}{"chain"}.$atoms{$atom}{"aaid"}}{"global"}++;
	    $aminoacids{$atoms{$atom2}{"chain"}.$atoms{$atom2}{"aaid"}}{"global"}++; 
	  }
	}
      }
    }
  }
}

#set the aminoacids' secondary structures
foreach my $helix (keys %helices){
  for(my $i = $helices{$helix}{"start"}; $i <= $helices{$helix}{"end"}; $i++){
    my $null = "";
    for(my $j = 0; $j < (4 - length($i)); $j++){
      $null.= "0";
    }
    $aminoacids{$helices{$helix}{"chain"}.$null.$i}{"secondary"} = "a";
  }
}
foreach my $sheet (keys %sheets){
  for(my $i = $sheets{$sheet}{"start"}; $i <= $sheets{$sheet}{"end"}; $i++){
    my $null = "";
    for(my $j = 0; $j < (4 - length($i)); $j++){
      $null.= "0";
    }
    $aminoacids{$sheets{$sheet}{"chain"}.$null.$i}{"secondary"} = "b";
  }
}


my @order = sort(keys %aminoacids);
#print sscc on STDOUT
foreach my $key (@order){
  print $aminoacids{$key}{"type"}."\t".$aminoacids{$key}{"secondary"}."\t".$aminoacids{$key}{"local"}."\t".$aminoacids{$key}{"global"}."\n";
}

#save distances to txt-file
open (FH, ">$pdbid"."_distances.txt");
foreach my $key (@order){
  print FH "\t".$key;
}
print FH "\n";
foreach my $key (@order){
  print FH $key."\t";
  foreach my $key2 (@order){
    if($key eq $key2){
      print FH "0.\t";
    }
    else{
      print FH $distances{$key}{$key2}."\t";
    }
  }
  print FH "\n";
}
close FH;

#save matrix to txt-file
open (FH,">$pdbid"."_matrix.txt");
foreach my $key (@order){
  print FH "\t".$key;
}
print FH "\n";
foreach my $key (@order){
  print FH $key;
  foreach my $key2 (@order){
    print FH "\t";
    if($key eq $key2){
      print FH "undef";
    }
    if(exists $matrix{$key}{$key2}){
      print FH $matrix{$key}{$key2};
    }
  }
  print FH "\n";
}
close FH;

#make distance file into a R-Heatmap
open (FH,">heatmap.R");
print FH 'dist <- read.csv("'.$pdbid.'_distances.txt", sep = "\t")'."\n";
print FH 'matrix <- data.matrix(dist)'."\n";
print FH 'png("'.$pdbid.'_heatmap.png")'."\n";
print FH 'heatmap(matrix, Rowv = NA, Colv = NA, main = "Distances in '.$pdbid.'", xlab = "aminoacids", ylab = "aminoacids", labRow = "", labCol = "")'."\n";
print FH 'surpress <- dev.off()'."\n";

system("Rscript", "heatmap.R");

#delete temporary files
unlink($pdbid."_distances.txt");
unlink("heatmap.R");
