#!/usr/bin/perl -w
use strict;

open(FH, "U00096.ffn");
my $sequence = join("", <FH>);
$sequence =~ s/\>gi.+\n//;
my @sequences = split(/\>gi.+\n/, $sequence);
for(my $i = 0; $i < $#sequences; $i++){
	$sequences[$i] =~ s/[^ATGC]//g;
}

my $n = $ARGV[0];
chomp($n);
my %combinations = ();
for(my $i = 0; $i < $#sequences; $i++){
	for(my $j = 0; $j < length($sequences[$i]) - $n; $j++){ 
		my $here = substr($sequences[$i], $j, $n);	
		if(!exists $combinations{$here}){
			$combinations{$here} = $i;
		}
		else{
			if($combinations{$here}	ne $i){
				$combinations{$here} = -1;
			}	

		}
	}
}


my $x = 0;
my %unique;
while (my ($key, $value) = each(%combinations)){
	if($value != -1){
		$unique{$value} = 1;
	}
	
}

while (my ($key, $value) = each(%unique)){
	$x++;	
}

print $x/$#sequences."\n";
