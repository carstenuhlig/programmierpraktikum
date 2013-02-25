#!/usr/bin/perl
use LWP::Simple;
use DBI;
#chomp($ARGV[0]);
open (FILE, $ARGV[0]) or die "File does not exist";
@seq = <FILE>;
#print $seq[0];
$foo = @seq;
my $sequence = "";
for($i = 0; $i<$foo; $i++){
	chomp($seq[$i]);
	$sequence .= $seq[$i];
}

my $reversesequence = reverse $sequence;
$reversesequence =~ s/A/U/g;
$reversesequence =~ s/T/A/g;
$reversesequence =~ s/U/T/g;
$reversesequence =~ s/C/U/g;
$reversesequence =~ s/G/C/g;
$reversesequence =~ s/U/G/g;

#my @hits = ('');
#my @locations = ('');
#my @lengths = ('');
#while($sequence =~ m/(ATG(...)+?(TAG|TAA|TGA))/g){
#	#print ("Hallo");
#	push(@hits, $1);
#	push(@locations, $-[0]);
#	push(@lengths, length($1));
#}

sub ctorfs{
$seq = shift;
my @hits = ('');
while($seq =~ m/(ATG([ATGC]{3}(?!ATG))+?(TAG|TAA|TGA))/g){
#	if(length($1) > 230) {
#		if(length($1) < 307){
		push(@hits, length($1));
#		}
#		}
	}
return @hits;
}

sub clengths{
$seq = shift;
my @hits = ('');
while($seq =~ m/(ATG(...)+?(TAG|TAA|TGA))/g){
	push(@hits, length($1));
	}
return @hits;
}

#make length statistics
sub lengthstats{
$seq = shift;
my @hits = ('');
for($i = 0; $i < 2000; $i++){
$hits[$i] = 0;}
while($seq =~ m/(ATG(...)+?(TAG|TAA|TGA))/g){
	$l = length($1);
	$hits[$l]++; 
	}
return @hits;
}


sub cpos{
$seq = shift;
my @pos = ('');
while($seq =~ m/(ATG(...)+?(TAG|TAA|TGA))/g){
#	if(length($1) > 230) {
#		if(length($1) < 307){
		push(@pos, $-[0]);
#		}
#		}
	}
return @pos;
}

#$h = ctorfs($sequence);
#$h2 = ctorfs($reversesequence);

my $dbh = DBI->connect("DBI:mysql:bioprakt6:mysql2-ext.bio.ifi.lmu.de", "bioprakt6", "JzJyggflWG") or die "Error connecting to database.";
my $seq_query = $dbh->prepare("SELECT COUNT(*) FROM sequences WHERE sequence = \'$sequence\'");
$seq_query->execute();
my @num = $seq_query->fetchrow_array();

print $num[0];

if($num[0] < 1){
$seq_query = $dbh->prepare("INSERT INTO sequences \(sequence\) VALUES\(\'$sequence\'\)");
$seq_query->execute();
}

@hits=(ctorfs($sequence), ctorfs($reversesequence));
@pos=(cpos($sequence), cpos($reversesequence));

$foo = @hits;
for($i = 0; $i < $foo; $i++){
	my $endpos = $pos[$i]+$hits[$i];
	my $seq_query = $dbh->prepare("SELECT COUNT(*) FROM orfs WHERE fromseq = '4' and startpos = \'$pos[$i]\' and endpos =\'$endpos\'");
	$seq_query->execute();
	my @num = $seq_query->fetchrow_array();
	if($num[0] < 1){
	$seq_query = $dbh->prepare("INSERT INTO orfs \(fromseq, startpos, endpos\) VALUES\('4', \'$pos[$i]\', \'$endpos\'\)");
	$seq_query->execute();
	}
}
$sequencejd = $sequence . $reversesequence;
@lengthstats = lengthstats($sequencejd);
$bar = @lengthstats;
for($i = 0; $i < $bar; $i++) {
if($lengthstats[$i]!=0){
print("\n $i");
}
	for ($j = 0; $j < $lengthstats[$i]; $j++){
		print ("X");	
		}
}

#print ;
#my @orfs1 = ('');
#my $numberorfs = 0;
#for($i = 0; $i < length(@hits); $i++){
#	if($lengths[i]<75){
#		if($lengths[i]>100){
#		$numberorfs++;
#		}
#	}
#}
#@fwdhits = split(/\./,$results[0]);
#$numberofhits = @hits;
#print $h;
#print "\n $h2";
#print $numberofhits;
#print $sequence;
#getprint("/home/proj/biocluster/praktikum/bioprakt/Data/Genomes/chri_230203.ascii");
#@seqarr = get("/home/proj/biocluster/praktikum/bioprakt/Data/Genomes/chri_230203.ascii");
#$sequence =join ("", @seqarr);
#print $sequence;
