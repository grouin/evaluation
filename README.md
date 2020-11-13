# evaluation
Scripts to make it easier evaluations

## Evaluation ##

L'évaluation du repérage d'entités nommées compare une référence à une hypothèse, tant sur les frontières des portions annotées, que sur les étiquettes associées à ces portions.

En l'absence de référence, la référence est établie par vote majoritaire entre sorties des systèmes (Jonathan Fiscus, 1997 : ROVER d'évaluation en reconnaissance de la parole).


Soit deux sorties sur un même document, les situations sont :

* aucune portion annotée ou portion annotée de manière identique
        Fichier A : [Armel Le Cléac'h] remporte haut la main la deuxième étape
	Fichier B : [Armel Le Cléac'h] remporte haut la main la deuxième étape

* portion annotée dans un seul fichier
        Fichier A : [Armel Le Cléac'h] remporte haut la main la deuxième étape
	Fichier B : Armel Le Cléac'h remporte haut la main la deuxième étape

* portions annotées différemment

** imbrication de portions
        Fichier A : [Armel Le Cléac'h] remporte haut la main la deuxième étape
	Fichier B : Armel [Le Cléac'h] remporte haut la main la deuxième étape

** chevauchement de portions
        Fichier A : [Armel Le Cléac'h] remporte haut la main la deuxième étape
	Fichier B : Armel [Le Cléac'h remporte] haut la main la deuxième étape

** nombre différents de portions
        Fichier A : [Armel Le Cléac'h] remporte haut la main la deuxième étape
	Fichier B : [Armel] [Le Cléac'h] remporte haut la main la deuxième étape

S'il n'existe qu'un seul système participant, on cherchera des portions répétées ou similaires dans les documents traités.

