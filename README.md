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

 * imbrication de portions

	Fichier A : [Armel Le Cléac'h] remporte haut la main la deuxième étape
	
	Fichier B : Armel [Le Cléac'h] remporte haut la main la deuxième étape

 * chevauchement de portions

	Fichier A : [Armel Le Cléac'h] remporte haut la main la deuxième étape
	
	Fichier B : Armel [Le Cléac'h remporte] haut la main la deuxième étape

 * nombre différents de portions

	Fichier A : [Armel Le Cléac'h] remporte haut la main la deuxième étape
	
	Fichier B : [Armel] [Le Cléac'h] remporte haut la main la deuxième étape

S'il n'existe qu'un seul système participant, on cherchera des portions répétées ou similaires dans les documents traités.


## Scripts

### Alignement d'annotations

Pour un fichier texte et plusieurs versions annotées (sorties de différents systèmes) au format BRAT, aligne les annotations produites pour établir un ROVER.

	perl outputs-alignment.pl texte.txt systeme1.ann systeme2.ann systeme3.ann ...

	perl outputs-alignment.pl ref/363052.txt sys1/363052.ann sys2/363052.ann sys3/363052.ann


### Classe majoritaire

A partir de l'alignement précédent, identifie la classe majoritaire ; en cas d'ex-aequo, la première classe par ordre alphabétique est retenue ; sur un schéma BIO, cela permet de privilégier les annotations B-xxx ou I-xxx au détriment des classes O (absence d'annotation) :

	perl outputs-alignment.pl texte.txt systeme1.ann systeme2.ann systeme3.ann ... | perl rover-production.pl

	perl outputs-alignment.pl ref/363052.txt sys1/363052.ann sys2/363052.ann sys3/363052.ann | perl rover-production.pl

Ce deuxième script ajoute une colonne avec le vote majoritaire.


### Conversion au format BRAT

A partir du vote majoritaire précédemment identifié, effectue une conversion au format BRAT :

	perl outputs-alignment.pl texte.txt systeme1.ann systeme2.ann systeme3.ann ... | perl rover-production.pl | perl brat-conversion.pl >reference.ann

	perl outputs-alignment.pl ref/363052.txt sys1/363052.ann sys2/363052.ann sys3/363052.ann | perl rover-production.pl | perl brat-conversion.pl >ref/363052.ann

Ce dernier script récupère les annotations majoritaires et produit un fichier d'annotations au format BRAT pour pouvoir lancer les évaluations avec l'outil BRATeval une fois que toutes les conversions ont été réalisées :

	java -cp BRATEval-0.0.2-SNAPSHOT.jar au.com.nicta.csp.brateval.CompareEntities ref/ sys1/ true

	java -cp BRATEval-0.0.2-SNAPSHOT.jar au.com.nicta.csp.brateval.CompareEntities ref/ sys2/ true

	java -cp BRATEval-0.0.2-SNAPSHOT.jar au.com.nicta.csp.brateval.CompareEntities ref/ sys3/ true


## Exemples

Les répertoires ref/ sys1/ sys2/ sys3/ contiennent un fichier texte dans le premier répertoire et trois versions annotées de ce fichier dans les répertoires sys* issus du projet MIAM.
