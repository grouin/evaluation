#!/usr/bin/perl

# Après alignement de fichiers *ann vides, produit des annotations
# aléatoires pour vérifier le bon fonctionnement du ROVER sur de gros
# volumes de données (le fichier 3549.txt fait 5,1 Mo ; l'alignement
# avec 4 fichiers vides fait 90 Mo).

# time perl outputs-alignment.pl 3549.txt 3549.ann 3549.ann 3549.ann 3549.ann | perl random-annot.pl | perl rover-production.pl | perl brat-conversion.pl >3549.ann2

# 0	I	O	O	O	O
# 1	l	O	O	O	O
# 2	SPACE	O	O	O	O
# 3	c	O	O	O	O
# 4	o	O	O	O	O
# 5	u	O	O	O	O
# 6	v	O	O	O	O
# 7	r	O	O	O	O
# 8	e	O	O	O	O
# 9	SPACE	O	O	O	O


use utf8;
binmode STDOUT, ":encoding(utf8)";

my @tags=("drug","dosage","food","interaction","mealTime","pharmacokinetics","value");
my @prec;
my @taille;

while (my $ligne=<STDIN>) {
    chomp $ligne;
    my @cols=split(/\t/,$ligne);
    
    # Traitement par colonne : on reproduit l'offset et le caractère
    print "$cols[0]\t$cols[1]";
    # Pour chaque colonne d'annotation
    for (my $i=2;$i<=$#cols;$i++) {
	# Tirage aléatoire : dimension du tableau de labels + valeur à
	# fixer pour conserver plus ou moins de labels "O" d'origine
	my $alea=int(rand($#cols+40));
	my $tag="O"; if ($alea<7) { $tag=$tags[$alea]; }
	# On continue d'utiliser l'étiquette précédente tant que la
	# portion couverte n'atteint pas un seuil pour éviter des
	# portions composées d'un seul caractère
	if ($taille[$i]<=length($prec[$i]) && $prec[$i] ne "") { $tag=$prec[$i]; } else { $taille[$i]=0; }
	# Pas d'annotation sur un saut de ligne (LINE)
	if ($cols[1]=~/LINE/) { $tag="O"; }
	# Préfixe B-/I- en fonction du labels de la ligne précédente
	my $pre=""; if ($tag ne "O") { if ($tag eq $prec[$i]) { $pre="I-"; } else { $pre="B-"; }}
	# Pas de début d'annotation sur une espace
	if ($cols[1]=~/SPACE/ && $pre eq "B-") { $tag="O"; $pre=""; }
	print "\t$pre$tag";
	# Mémorisation de l'étiquette attribuée par colonne
	$prec[$i]=$tag;
	$taille[$i]++;
    }

    print "\n";
}

