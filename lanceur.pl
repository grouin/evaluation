#!/usr/bin/perl

# Un répertoire contient les textes, plusieurs répertoires contiennent
# les annotations au format BRAT. Le script aligne les différentes
# versions annotées.

# perl lanceur.pl ref/ sys1/ sys2/ sys3/

use strict;

my @chemins=@ARGV;

# Solution simple : le premier dossier contient les textes, tous les
# autres contiennent les annotations

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
    system("perl outputs-alignment.pl $commande | perl rover-production.pl | perl brat-conversion.pl >$sortie");
}
