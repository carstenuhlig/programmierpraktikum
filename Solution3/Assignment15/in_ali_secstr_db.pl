#!/usr/bin/perl -w

use strict;
use Getopt::Std;
use DBI;

my $dbh = DBI->connect("DBI:mysql:bioprakt6:mysql2-ext.bio.ifi.lmu.de","bioprakt6","JzJyggflWG") or die "Error connection database!";
my $dbsource = 'HOMSTRAD'; #falls andere dann hier bitte ändern!

my %opts;
getopts('d:', \%opts);

opendir(DIR,$opts{d}) or die ": ordner nicht gefunden $opts{n}\n";

# obsolet
sub doStuff {
   foreach (@_) {
      if ( $_ ) {
         #print $_,"\n";
      }
   }
}

# obsolet
sub processAli {
   # hier datei.ali parsen mit hash rückgabe 
   open FILE, "<$_[0]" or die $!;
   my %hashcontainer = ();
   my @ids = ();
   my @sequences = ();
   my $sequence = '';
   my $lastlinecounter = 0;

   while (<FILE>) {

      # id extract
      if ( $_ =~ m/^\>P1\;([^\s]*) *\n$/ )
      {
         push(@ids,"$1");
         $lastlinecounter++;
      }

      # sequenz extract
      if ( $_ =~ m/^([A-Z|\-]+)/ ) # last line evtl auch benötigt da manchmal buchstaben capitalized sind
      {
         if ($lastlinecounter == 2) { # falls zeile von typ übersprungen dann ... bla
            $sequence .= "$1";
            if ( $_ =~ m/\*$/ ) {
               push(@sequences,"$sequence");
               $sequence = '';
               $lastlinecounter = 0;
            }
         } else {
            if ($lastlinecounter == 1) {
               $lastlinecounter++;
            } 
         }
      }
      $hashcontainer{ids} = [@ids];
      $hashcontainer{sequences} = [@sequences];
      close(FILE);
      return \%hashcontainer;
}
}

# obsolet
sub processTem {
   # hier datei.tem parsen mit hash rückgabe
   open FILE, "<$_[0]" or die $!;
   my %hashcontainer = ();
   # ids
   my @ids = ();
   # sequenz
   my @sequences = ();
   my $sequence = '';
   # für typ suche
   my @types = ();
   my $lastlinewasid = 0;
   while (<FILE>) {
      # type extract
      if ( $lastlinewasid ) {
         my $tmp = chomp($_);
         #print $_;
         push(@types,$tmp);
         $lastlinewasid = 0;
      }

      # id extract
      if ( $_ =~ m/^\>P1\;([^\s]*)/ )
      {
         push(@ids,"$1");
         $lastlinewasid = 1;
      }

      # sequenz extract
      if ( $_ =~ m/^([A-Z|\-]+)/ && !$lastlinewasid )
      {
         my $tmp = "$1";
         $tmp =~ s/DSSP//; # manchmal sehr komische vorkommnisse...
         $sequence .= $tmp;
         if ( $_ =~ m/\*$/ ) {
            push(@sequences,"$sequence");
            $sequence = '';
         }
      }
   }

   # einspeicherung der werte in hash
   $hashcontainer{ids} = [@ids];
   $hashcontainer{sequences} = [@sequences];
   $hashcontainer{types} = [@types];

   close(FILE);
   return \%hashcontainer;
}

# raw sequenz von alignment zurückgeben
sub getRawSeq {
   my $tmp = $_[0] =~ s/\-//g;
   return "$tmp";
}

# id von sequenz suchen und zurückgeben
sub getIdFromSeq {
   my $mysql_query = $dbh->prepare("SELECT id FROM sequences WHERE sequence = ?");
   $mysql_query->execute($_[0]);
   my @tmparray = $mysql_query->fetchrow_array();
   $mysql_query->finish();

   if ($#tmparray == -1) {
      return -1;
   }
   else {
      #print $tmparray[0];
      return $tmparray[0];
   }
}

# insertMultipleAlignment without update
# soll heißen wenn sequenz noch nicht vorhanden dann 
# einfügen von daten, aber wenn vorhanden
# dann kein einfügen und einfach weiter
# -> weitere methode muss noch erstellt werden
sub insertMultipleAlignment {
   my $mysql_query = $dbh->prepare("INSERT INTO structure_alignments(structure_alignment,fromseq,align_id) VALUES (?,?,?)");
   $mysql_query->execute($_[0],$_[1],$_[2]);
   $mysql_query->finish();
}

# insertSecondaryStrucures
sub insertSecondaryStrucures {
   my $mysql_query = $dbh->prepare("INSERT INTO secondary_structures(secondary_structure,fromseq,type) VALUES (?,?,?)");
   $mysql_query->execute($_[0],$_[1],$_[2]);
   $mysql_query->finish();
}

# insertSeq
# nur sequenz und dbsource werden eingefügt
sub insertSeq {
   #print $_[0]," ",$dbsource,"\n";
   my $mysql_query = $dbh->prepare("INSERT INTO sequences(sequence,dbsource,pdbid) VALUES (?,?,?)");
   #print $_[1];
   $mysql_query->execute($_[0],$dbsource,$_[2]);
   $mysql_query->finish();

}

# insertPDBID
# fromseq und pdbid input parameter
sub insertPDBID {
   my $mysql_query = $dbh->prepare("INSERT INTO pdbids(pdbid,fromseq) VALUES (?,?)");
   $mysql_query->execute($_[0],$dbsource);
   $mysql_query->finish();
}

# get id from seq from pdbid
sub getIdFromPDBID {
   my $mysql_query = $dbh->prepare("SELECT 'id' FROM sequences WHERE pdbid = ?");
   $mysql_query->execute($_[0]);
   my @tmparray = $mysql_query->fetchrow_array();
   $mysql_query->finish();

   if ($#tmparray == -1) {
      return -1;
   }
   else {
      #print $tmparray[0];
      return $tmparray[0];
   }
}

# obsolet
# insert
# drei methoden in einem
sub insert {
   # nur mit references möglich
   my ( $aliref,$temref ) = @_;
   my %ali = %{$aliref};
   my %tem = %{$temref};
   my $last_id = -1;
   my $align_id = -1;
   for my $i ( 0 .. $#{ $ali {sequences} } ) {
      my $seq = getRawSeq($_);
      if (getIdFromSeq($seq)) {
         # update table 
      } else {
         insertSeq($seq);
         $last_id = mysql_insert_id();
         if ($align_id == -1) {
            $align_id = $last_id;
         }
         insertMultipleAlignment(@{$ali{sequences}}["$i"],$last_id,$align_id);
         insertSecondaryStrucures(@{$tem{sequences}}["$i"],$last_id,@{$tem{types}}[$i]);
         insertPDBID(@{$tem{ids}}["$i"],$last_id); #könnte auch mehrere pdb ids für eine sequenz bzw ein alignment oder sec structure geben
      }
   }
}

# $counter für test zwecke um anzahl an eingelesenen dateien zu begrenzen
my $counter = 0;
# einlesen der dateien
while (my $f = readdir(DIR)) { # homstrad ordner
   if ($f !~ m/^\./ ) { 
      # werden versteckte (.dateiname) dateien nicht aufgerufen
      opendir(SUBDIR,"$opts{d}\/$f\/") or die "ordner nicht vorhanden: $!\n";
      while (my $sf = readdir(SUBDIR)) { #unterodern = domäne

# hier datei.t#em parsen mit hash rückgabe
         if ( $sf =~ m/.tem$/ ) {
            open FILE, "<$opts{d}\/$f\/$sf" or die $!;
            # ids
            my @ids = ();
            # sequenz
            my $sequence = '';
            my @sequences = ();
            # für typ suche
            my $lastlinecount = 0;
            my $isalignment = 0;
            my $issec= 0;
            my $isdssp= 0;
            my @dssp = ();
            my @alignment = ();
            my @secstructure = ();
            my $idsread = 0;
            my $changed = 0;

            while (<FILE>) {
               # type extract
               if ( $lastlinecount == 1) {
                  my $tmp = $_;
                  $tmp =~ s/\n//;
                  if ( $tmp =~ m/^sequence$/ ) {
                     $isalignment = 1;
                  } else {
                     $idsread = 1;
                  }
                  if ( $tmp =~ m/^secondary structure and phi angle$/ ) {
                     $issec = 1;
                  }
                  if ( $tmp =~ m/^DSSP$/ )
                  {
                     $isdssp = 1;
                  }
                  $lastlinecount = 2;
               }

               # id extract
               if ( $_ =~ m/^\>P1\;([^\s]*)/ )
               {
                  #print $;
                  if (!$changed && $idsread ) {
                     $changed = 1;
                     pop(@ids);
                  }
                  if ( !$idsread ) {
                     push(@ids,$1);
                  }
                  $lastlinecount = 1;
               }



               # sequenz extract
               if ( $_ =~ m/^([A-Z0-9\-]+)\*?/ && $lastlinecount == 2 )
               {
                  my $tmp = $1;
                  $sequence .= $tmp;
                  if ( $_ =~ m/\*$/ ) {
                     if ( $isalignment ) {
                        push(@alignment,$sequence);
                        my $rawseq = $sequence;
                        $rawseq =~ s/\-//g;
                        push(@sequences,$rawseq);
                        $isalignment = 0;
                     }
                     if ( $issec ) {
                        push(@secstructure,$sequence);
                        $issec = 0;
                     }
                     if ( $isdssp ) {
                        $sequence =~ s/^DSSP//;
                        push(@dssp,$sequence);
                        $isdssp = 0;
                     }
                     $sequence = '';
                     $lastlinecount = 0,
                  }
               }
            }

            for my $someval (0 .. $#ids) {
#          print "id\: $ids[$someval]\n";
#          print "sequence\: $sequences[$someval]\n";
#          print "alignment\: $alignment[$someval]\n";
#          print "secondary structure: $secstructure[$someval]\n";
#          print "dssp\: $dssp[$someval]\n";
#          print "file\: $sf\n";
#          print "\n\n";
               if ( $dssp[0] ) {
                  if ( $dssp[$someval] =~ m/^DSSP/ ) {
                     print $sf;
                     # falls "DSSP" in sequenz auftritt datei angeben um format zu überprüfen
                  }
               }
            }


            close(FILE); #jetzt in datenbank hinzufügen
            #exit 1;

            my $align_id = -1;
            for my $i ( 0 .. $#ids ) {
               my $foundid = getIdFromSeq($sequences[$i]);
               if ($foundid == -1) {
                  #print $ids[$i];
                  if ( exists $sequences[$i] ) {
                     insertSeq($sequences[$i],$dbsource,$ids[$i]);
                     my $lastinsertid = getIdFromSeq($sequences[$i]);
                     if ($align_id == -1)
                     {
                        $align_id = $lastinsertid;
                     }
                     insertSecondaryStrucures($secstructure[$i],$lastinsertid,'secondary structure and phi angle');
                     if (exists $dssp[$i]) {
                        insertSecondaryStrucures($dssp[$i],$lastinsertid,'DSSP');
                     }
                     insertMultipleAlignment($alignment[$i],$lastinsertid,$align_id);
                  } 
               }
            }
         }
         $counter++;
         if ( $counter == 100) {
            #exit 1;
         }
      }
      closedir(SUBDIR);
   }
}
closedir(DIR);
$dbh->disconnect();
