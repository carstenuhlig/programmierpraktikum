#!/usr/bin/perl
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

#eliminate -
my $regex = $regexOrig;
$regex =~ s/-//g;
#change x to .
$regex =~ s/x/./g; #[ARNDBCEQZGHILKMFPSTWYV]
#change {xyz} to [^xyz]
$regex =~ s/\{(.+)\}/\[^$1\]/g;
#change (d) to {d}
$regex =~ s/\(((\d|,)+)\)/\{$1\}/g;

my $filename = <STDIN>;
open(fh, $filename);
my $fasta = join("", <fh>);
my $result = "";
if($opt{e}) { 
	use LWP::UserAgent; 
	use HTTP::Request::Common qw{ POST };
	my $url = "http://prosite.expasy.org/cgi-bin/prosite/PSScan.cgi";
	my $ua     = LWP::UserAgent->new();
	my $request = POST($url, [ 'seq' => $fasta , 'sig' => $regexOrig, 'output'=>'txt'] );
	$result = $ua->request($request)->content;
	chomp $result;
}
else{
$fasta =~ s/>.*\n//;
$fasta =~ s/\n//g;

while($fasta =~ m/($regex)/g){
my $endPos = pos $fasta;
my $startPos = $endPos - length($1) + 1;
$result = $result.$startPos."\t".$1."\n";
}
}
print "$result\n";


