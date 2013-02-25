#!/usr/bin/perl -w
use strict;
use DBI;
use Getopt::Std;

my %opts = ();
getopts("f:d:",\%opts);

if (!$opts{f} || !$opts{d}) {
  die "Bitte -f für swissprot .dat datei und -d mit datenquellennamen angeben. ->Fehler!";
}

open FILE , "<" , $opts{f};
my ($line,$seq,$os,@kw,$id,@ac,$tmp,@tmparray,$ox,$dbsource);

$dbsource = $opts{d};

$os = '';
$id = '';
$seq = ();
@kw = ();
my $sql_query = '';

#Verbindung zur Datenbank:
#my $mysql_query = $dbh->prepare("");

my $dbh = DBI->connect("DBI:mysql:bioprakt6:mysql2-ext.bio.ifi.lmu.de","bioprakt6","JzJyggflWG") or die "Error connection database!";
#$mysql_query = $dbh->prepare("SELECT * FROM sequences");
#$mysql_query->execute();
#my @num = $mysql_query->fetchrow_array();

#print $mysql_query->dump_results();


# funktionen:
# fügt sequenz hinzu mit attributen sequence,identifier = ID und organism = OS
sub insertSequence {
  my $mysql_query = $dbh->prepare("INSERT INTO sequences(sequence,identifier,organism,organism_taxonomy,dbsource) VALUES (?,?,?,?,?)");
  $mysql_query->execute($_[0],$_[1],$_[2],$_[3],$_[4]);
  $mysql_query->finish();
}

# fügt accession nummern hinzu
sub insertAccessionNr {
  my @tmparray = @{$_[1]};
  my $tmpfromseq = $_[0];
  foreach (@tmparray) {
    my $mysql_query = $dbh->prepare("INSERT INTO accession_nr(accession,fromseq) VALUES (?,?)");
    $mysql_query->execute($_,$tmpfromseq);
    $mysql_query->finish();
  }
}

# fügt keywords hinzu
sub insertKeywords {
  my @tmparray = @{$_[1]};
  my $tmpfromseq = $_[0];
  foreach (@tmparray) {
    my $mysql_query = $dbh->prepare("INSERT INTO keywords(keyword,fromseq) VALUES (?,?)");
    $mysql_query->execute($_,$tmpfromseq);
    $mysql_query->finish();
  }
}	

# gibt id einer sequenz zurück
sub getIdFromSeq {
  my $mysql_query = $dbh->prepare("SELECT * FROM sequences WHERE sequence = ?");
  $mysql_query->execute($_[0]);
  my $tmphashref = $mysql_query->fetchrow_hashref();
  my $tmpid = $ { $tmphashref } { id };
  $mysql_query->finish();
  return $tmpid;
}

while ($line =<FILE>) {
#	switch ($line) {
#		case /^ID   ([^\n])*\n/	{	$id = $1; print $1;	}
#		case /^OS   ([^\n])*\n/	{	$os = $1;	}
#		case /^KW   ([^\n])*\n/	{	push(@kw,split( "; ",$1 ));	}
#		case /^     ([^\n])*\n/	{	push($seq,$1);}
#		case /\/\/\n/ { print "Organism = $os; ID = $id; KW = "}
#	}
  if ($line =~ m/^ID   ([^\s^\n]*).*\n/) {
    $tmp = $1;
    $tmp =~ s/\.//g;
    $id = $tmp;
  }
  if ($line =~ m/^OS   (.*)\n/) {
    $tmp = $1;
    $tmp =~ s/\.//g;
    $os = "$os"." $tmp";
  }
  if ($line =~ m/^AC   (.*)\n/) {
    $tmp = $1;
    $tmp =~ s/;$//;
    @tmparray = split(/\; /,$tmp);
    @ac = (@ac,@tmparray);
    @tmparray = ();
    $tmp = '';
  }
  if ($line =~ m/^     (.*)\n/) {
    $tmp = $1;
    $tmp =~ s/[ |\n]//g;
    $seq = $seq.$tmp;
    $tmp = '';
  }
  if ($line =~ m/^KW   (.*)\n/) {
    $tmp = $1;
    $tmp =~ s/\.//g;
    $tmp =~ s/;$//;
    @tmparray = split(/\; /,$tmp);
    @kw = (@kw,@tmparray);
    @tmparray = ();
    $tmp = '';
  }
  if ($line =~ m/^OX   (.*)\;\n/) {
    $tmp = $1;
    $tmp =~ s/[\.]//g;
    $ox = $tmp;
  }
  if ($line =~ m/\/\/\n/) {
#		print "\n";
#		print "ID = "."$id"."\n";
#		print "AC = ", join("+",@ac),"\n";
#		print "OS = "."$os"."\n";
#		print "OX = "."$ox"."\n";
#		print "Sequenz = ",$seq,"\n"; 

    my $mysql_query = $dbh->prepare("SELECT `id` FROM sequences WHERE sequence = ?");
    $mysql_query->execute($seq);
    my $sequence_id = 0; 
    my @result = $mysql_query->fetchrow_array();
    if ($#result == -1) {
# insert id
      insertSequence($seq,$id,$os,$ox,$dbsource);

      $sequence_id = $dbh->last_insert_id(undef, undef, undef, undef);
    } else {
      $sequence_id = $result[0];
    }
    $mysql_query->finish();

    insertKeywords($sequence_id,\@kw);
  insertAccessionNr($sequence_id,\@ac);

  $os = '';
  $id = '';
  @ac = ();
  @kw = ();
  $seq = '';
  $ox = '';

}
}
$dbh->disconnect();
