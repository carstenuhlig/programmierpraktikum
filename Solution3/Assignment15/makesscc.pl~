#!/usr/bin/perl -w
#use LWP::Simple;

use CGI;
use CGI::Carp qw(fatalsToBrowser);
use DBI;

my $q = CGI->new;
print $q->header(), $q->start_html, $q->h1("SQL Statement");

my $pdbid  = $q->param('L1');
my $pdbid2 = $q->param('L2');

my $dbh = DBI->connect( "DBI:mysql:bioprakt6:mysql2-ext.bio.ifi.lmu.de",
    "bioprakt6", "JzJyggflWG" )
  or die "Error connection database!";

if ( $pdbid ne '' && $pdbid2 ne '' ) {

    # fall wenn 2 pdb ids angegeben
    my $mysql_query = $dbh->prepare(
"SELECT seq1.pdbid,S1.structure_alignment,seq2.pdbid,S2.structure_alignment
      FROM 
      structure_alignments S1, sequences seq1, structure_alignments S2, sequences seq2 
      WHERE 
      seq1.pdbid = ? AND S1.fromseq = seq1.id AND seq2.pdbid = ? AND S2.fromseq = seq2.id AND S1.align_id = S2.align_id; 
      "
    );
    $mysql_query->execute( $pdbid, $pdbid2 );
    my @mysql_array = $mysql_query->fetchrow_array();
    $mysql_query->finish();
    if ( $#mysql_array == -1 ) {
        print $q->p("nichts gefunden");
    }
    else {
        print $q->p("gefunden:");
        print $q->p("$mysql_array[0]");
        print $q->("$mysql_array[1]");
        print $q->p("");
        print $q->p("$mysql_array[2]");
        print $q->blockquote("$mysql_array[3]");
    }
}
else {

    # fall wenn nur eine pdb id angegeben
    print $q->p("Nur eine PDBID wird abgefragt: $pdbid");
    my $mysql_query = $dbh->prepare(
        "SELECT seq.pdbid,sec.type,sec.secondary_structure
      FROM
      sequences seq,secondary_structures sec
      WHERE
      seq.pdbid = ? AND seq.id = sec.fromseq"
    );
    $mysql_query->execute($pdbid);
    my @data    = ();
    my $printed = 0;
    while ( @data = $mysql_query->fetchrow_array() ) {

        if ( $#data == -1 ) {
            if ( !$printed ) {
                print $q->p("$printed");
                print $q->p("SSCC: keine sekundären Strukturen gefunden.");
            }

        }
        else {
            print $q->p("$data[0]\, $data[1]\:");
            print $q->p("");
            print $q->blockquote("$data[2]");
            $printed = 1;
        }
    }
    $mysql_query->finish();

    print $q->p("--------------------");
    print $q->p();
    print $q->p();
    print $q->p();
    print $q->p();
    print $q->p();

    my $mysql_query = $dbh->prepare(
"SELECT seq1.pdbid,str1.structure_alignment,seq2.pdbid,str2.structure_alignment
      FROM
      sequences seq1,structure_alignments str1,structure_alignments str2,sequences seq2
      WHERE
      seq1.id = str1.fromseq AND seq2.id = str2.fromseq AND seq1.pdbid = ? AND str1.align_id = str2.align_id AND str1.id <> str2.id"
    );
    $mysql_query->execute($pdbid);
    while ( @data = $mysql_query->fetchrow_array() ) {
        if ( $#data == -1 ) {
            print $q->p("SSCC: keine multiplen Alignments gefunden.");
        }
        else {
            print $q->p("$data[0]\:");
            print $q->blockquote("$data[1]");
            print $q->p("");
            print $q->p("$data[2]\:");
            print $q->blockquote("$data[3]");
        }
    }

    $mysql_query->finish();
}
$dbh->disconnect();
print $q->end_html;
