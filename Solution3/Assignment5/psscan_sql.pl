#!/usr/bin/perl -w
use strict;

my $regex = $ARGV[0];

#change prosite regular expression to MySQL regular expression
$regex =~ s/-//g;
$regex =~ s/x/./g;
$regex =~ s/\{(.+)\}/\[^$1\]/g;
$regex =~ s/\(([\d|,]+)\)/\{$1\}/g;

#allows to add extra conditions to the query
my $cond = "";
if(defined $ARGV[1]){
  $cond = " AND ".$ARGV[1];
}
print 'SELECT id FROM sequences WHERE sequence REGEXP "'.$regex.'"'.$cond."\n";

