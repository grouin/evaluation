#!/usr/bin/perl

# A partir d'un alignement de sorties au format BRAT produit par le
# script out-put-alignment.pl (colonne d'offset, colonne de caractère
# ou token, autant de colonnes que de sorties alignées), identifie
# l'annotation majoritaire sur chaque ligne, en traitant la classe O
# en dernier (ordre alphabétique) en cas d'ex-aequo (on retient la
# classe annotée plutôt que l'absence d'annotation).

# Auteur : Cyril Grouin, novembre 2020.


# perl outputs-alignment.pl fichier.txt systeme1.ann systeme2.ann systeme3.ann ... | perl rover-production.pl
# perl outputs-alignment.pl ref/363052.txt sys1/363052.ann sys2/363052.ann sys3/363052.ann | perl rover-production.pl


use strict;
use utf8;
my $seuil=0;
my $prec="O";

while (my $ligne=<STDIN>) {
    chomp $ligne;
    my @cols=split(/\t/,$ligne);
    my %annot=();  # Stockage du nombre d'annotations par classe
    my $rover=0;   # Indique si une classe majoritaire est affichée ou pas
    
    # Seuil fixé à la moitié du nombre de colonnes d'annotations
    $seuil=($#cols-1)/2;

    # Récupération des classes dans chaque colonne d'annotation et du
    # nombre de fois où chaque classe est utilisée
    for (my $i=2;$i<=$#cols;$i++) { $annot{$cols[$i]}++; }
    
    # Affichage de l'annotation majoritaire : la première classe dont
    # le nombre d'annotations est supérieur ou égal au seuil. L'ordre
    # alphabétique permet de sélectionner des classes B-xxx ou I-xxx
    # avant un O en cas de nombre pair d'annotations.
    print "$ligne\t";
    foreach my $classe (sort keys %annot) {
	if ($annot{$classe}>=$seuil) {
	    if ($rover==0) {
		if (substr($classe,1) ne substr($prec,1) && $classe=~/^I/) { $classe=~s/^I/B/; }
		print "$classe";
		$rover=1; $prec=$classe;
	    }
	}
    }
    # Si le ROVER est impossible (annotations différentes dans chaque
    # colonne : aucune annotation n'émerge), on reproduit le label "O"
    # pour avoir le même nombre de colonnes sur chaque ligne en sortie
    if ($rover==0) { print "O"; $prec="O"; }
    print "\n";
}
