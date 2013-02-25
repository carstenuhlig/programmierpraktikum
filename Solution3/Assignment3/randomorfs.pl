#!/usr/bin/perl
use LWP::Simple;

my $sequence = "";
my $gccont = $ARGV[0];
#Construct random Orfs based on GC Content.
for($i = 0; $i < 230203; $i++){
	my $bas = rand(100);
	if($bas >= ($gccont)) {
		if($bas >= ($gccont+(100-$gccont)/2)){
			$sequence.="A";
			}
		else{$sequence.="T";}
	}
	else {
		if($bas <= ($gccont/2)){
			$sequence.="C";
			}
		else{$sequence.="G";}
	}
}
#Count ORFs with given length
sub ctorfs{
$seq = shift;
my @hits = ('');
while($seq =~ m/(ATG(...)+?(TAG|TAA|TGA))/g){
	if(length($1) > 231){
		if(length($1) < 307){
		push(@hits, $1);
		}
	}
}
return @hits;
}

@h = ctorfs($sequence);
$numberorfs = @h;
print $numberorfs;

for($i=232; $i<307; $i=$i+3){
      print $i;
      for($j = 0; $j<$numberorfs; $j++){
	    if(length($h[$j])==$i){
	    print ('X');
	    }
      }
}

#my @hits = ('');
#my @locations = ('');
#my @lengths = ('');
#while($sequence =~ m/(ATG(...)+?(TAG|TAA|TGA))/g){
#	print ("Hallo");
#	push(@hits, $1);
#	push(@locations, $-[0]);
#	push(@lengths, length($1));
#}
