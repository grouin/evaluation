#!/usr/bin/perl

# A partir du ROVER réalisé sur un alignement d'annotations, produit
# un fichier d'annotation de référence au format BRAT.

# Auteur : Cyril Grouin, novembre 2020.


# perl outputs-alignment.pl ref/363052.txt sys1/363052.ann sys2/363052.ann sys3/363052.ann | perl rover-production.pl | perl brat-conversion.pl >ref/363052.ann
# java -cp ../../brat/BRATEval-0.0.2-SNAPSHOT.jar au.com.nicta.csp.brateval.CompareEntities ref/ sys1/ true
# java -cp ../../brat/BRATEval-0.0.2-SNAPSHOT.jar au.com.nicta.csp.brateval.CompareEntities ref/ sys2/ true
# java -cp ../../brat/BRATEval-0.0.2-SNAPSHOT.jar au.com.nicta.csp.brateval.CompareEntities ref/ sys3/ true


use strict;
use utf8;

my ($debut,$fin,$token,$label,$i)=(0,0,"","",1);

while (my $ligne=<STDIN>) {
    chomp $ligne;
    my @cols=split(/\t/,$ligne);

    # Annotations au format BRAT
    if ($cols[$#cols]=~/^B-(.*)$/) { $label=$1; $debut=$cols[0]; $fin=$cols[0]; $token=$cols[1]; }
    elsif ($cols[$#cols]=~/^I/) { $token.="$cols[1]"; $fin=$cols[0]; }
    elsif ($cols[$#cols] eq "O" && $token ne "") { $token=~s/SPACE/ /g; $token=~s/LINE/\n/g; $fin++; print "T$i\t$label $debut $fin\t$token\n"; $token=""; $i++; }
}
