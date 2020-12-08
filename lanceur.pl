#!/usr/bin/perl

# Un répertoire contient des fichiers textes (ref/*txt), plusieurs
# répertoires contiennent les annotations correspondant aux précédents
# fichiers (sys1/ sys2/ sys3/), au format BRAT (*ann).
# Chaque soumission d'un même système d'une même équipe (autorisation
# de trois soumissions par équipe) est dans un répertoire différent.
# Le ROVER est appliqué sur toutes les soumissions reçues, quel que
# soit le nombre de soumissions par équipe.

# Ce lanceur applique les différents scripts : alignement des versions
# annotées des fichiers *txt, application du ROVER, et conversion des
# annotations majoritaires au format BRAT en enregistrant les sorties
# *ann générées dans le répertoire des fichiers textes (ref/).

# perl lanceur.pl ref/ sys1/ sys2/ sys3/

# Auteur : Cyril Grouin, novembre 2020.


use strict;

my @chemins=@ARGV;

# Solution simple : le premier dossier contient les textes, tous les
# répertoires suivants contiennent les annotations à aligner

my @textes=<$chemins[0]/*txt>;

foreach my $texte (@textes) {
    my $commande="$texte ";
    for (my $i=1;$i<=$#chemins;$i++) {
	my $ann=$texte;
	$ann=~s/$chemins[0]/$chemins[$i]/;
	$ann=~s/txt$/ann/;
	$commande.="$ann ";
    }
    my $sortie=$texte;
    $sortie=~s/txt$/ann/;
    warn "perl outputs-alignment.pl $commande | perl rover-production.pl 3.5 | perl brat-conversion.pl >$sortie\n";
    system("perl outputs-alignment.pl $commande | perl rover-production.pl 3.5 | perl brat-conversion.pl >$sortie");
}
