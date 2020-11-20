#!/usr/bin/perl

# Pour un fichier texte et plusieurs versions annotées (sorties de
# différents systèmes) au format BRAT, aligne les annotations
# produites pour établir un ROVER.

# perl outputs-alignment.pl texte.txt systeme1.ann systeme2.ann systeme3.ann ...
# perl outputs-alignment.pl ref/363052.txt sys1/363052.ann sys2/363052.ann sys3/363052.ann


# La version actuelle du script ne permet pas de gérer plusieurs
# annotations sur la même portion à l'intérieur d'un fichier.


# Pour un traitement du texte caractère par caractère, ce qui permet
# de mieux gérer les début et fin de portions annotées, utiliser la
# commande suivante dans &traiteTexte() : my @tokens=split(//,$texte);
#
# Pour une tokénisation classique : my @tokens=split(/\s/,$texte);
# mais cette solution est déconseillée pour deux raisons : (1) la
# tokénisation est réalisée sur l'espace, sans que les ponctuations ne
# soient décollées des tokens pour éviter un décalage d'offsets, ce
# qui engendre des portions avec les ponctuations intégrées dans
# l'annotation, et (2) le calcul de l'offset de la fin de portion est
# plus complexe à déterminer.

# Auteur : Cyril Grouin, novembre 2020.


use utf8;
use strict;

my @fichiers=@ARGV;
my %tabulaire=();
my $ref;


###
# Programme

foreach my $fichier (@fichiers) {
    $ref=&traiteTexte($fichier) if ($fichier=~/txt$/);
    &traiteAnnot($fichier) if ($fichier=~/ann$/);
}
&genereTabulaire();


###
# Routines

sub traiteTexte() {
    my $f=shift; my $texte=""; my %cont=();

    # Récupération du texte intégral
    open(E,'<:utf8',$f) or die "Impossible d'ouvrir $f\n";
    while (my $ligne=<E>) { $texte.=$ligne; }
    close(E);

    # Tokénisation et calcul d'index
    my @tokens=split(//,$texte); my $last=0;
    foreach my $token (@tokens) {
	my $idx=index($texte,$token,$last);
	my $cle; if ($idx<10) { $cle="000000$idx"; } elsif ($idx<100) { $cle="00000$idx"; } elsif ($idx<1000) { $cle="0000$idx"; } elsif ($idx<10000) { $cle="000$idx"; } elsif ($idx<100000) { $cle="00$idx"; } elsif ($idx<1000000) { $cle="0$idx"; } else { $cle=$idx; }
	$cont{$cle}=$token;
	$last=$idx+length($token);
    }
    return \%cont;
}

sub traiteAnnot() {
    my ($f,$n)=@_;
    my %annotations=();
    my %debutAnnot=();

    # Récupération des annotations
    open(E,'<:utf8',$f) or die "Impossible d'ouvrir $f\n";
    while (my $ligne=<E>) {
	chomp $ligne;
	my ($id,$infos,$texte)=split(/\t/,$ligne);
	my ($label,$debut,$fin)=split(/ /,$infos);
	if (!exists $debutAnnot{$debut}) { $debutAnnot{$debut}="B-$label"; }

	for (my $j=$debut;$j<$fin;$j++) {
	    if (!exists $annotations{$j}) { $annotations{$j}="I-$label"; }
	    else { warn "Annotation existante en position $j : $annotations{$j} vs. I-$label\n"; }
	}
    }
    close(E);

    # Production du tabulaire annoté
    foreach my $cle (sort keys %{$ref}) {
	my $offset=$cle; $offset=~s/^0*(\d)/$1/;
	my $tag="O"; if (exists $annotations{$offset}) { $tag=$annotations{$offset}; }
	if (exists $debutAnnot{$offset}) { $tag=$debutAnnot{$offset}; }
	#print "$offset\t${$ref}{$cle}\t$tag\n";
	$tabulaire{$cle}.="\t$tag";
    }
}

sub genereTabulaire() {
    # Génère le tabulaire avec une colonne d'offsets de caractère, le
    # token, et autant de colonnes que de fichiers d'annotations
    foreach my $cle (sort keys %tabulaire) {
	my $offset=$cle; $offset=~s/^0*(\d)/$1/;
	my $token=${$ref}{$cle}; $token=~s/\n/LINE/; $token=~s/ /SPACE/;
	print "$offset\t$token$tabulaire{$cle}\n";
    }
}
