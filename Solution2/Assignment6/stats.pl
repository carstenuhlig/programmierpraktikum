#!/usr/bin/perl
use LWP::Simple;

#download Uniprot/Swissprot search-site for reviewed entries
my $reviewedSwissSite = get("http://www.uniprot.org/uniprot/?query=reviewed%3Ayes");

#filter for shown number of results
$reviewedSwissSite =~ m/\ of \<strong\>(.+)\<\/strong\> results/;
my $reviewedSwiss = $1;

#download Uniprot/Swissprot search-site for all entries
my $allSwissSite = get("http://www.uniprot.org/uniprot/");

#filter for number of results
$allSwissSite =~ m/ of \<strong\>(.+)\<\/strong\> results/;
my $allSwiss = $1;

#download PDB home-site
my $pdbSite = get("http://www.rcsb.org/pdb/home/home.do");

#filter for shown number of structures
$pdbSite =~ m/Retrieve all structures in the PDB\"\>(.+)\<\/a\>/;
my $pdb = $1;

#print data
print "Uniprot\/SwissProt:\n Reviewed entries: $reviewedSwiss.\n All entries: $allSwiss\nPDB:\n All entries: $pdb\n";
