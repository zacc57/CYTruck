#!/bin/bash

export LC_NUMERIC="en_US.UTF-8" #permet nombre flottant avec awk 
                                #compatibilité fichier csv



#plus de visibilité sur le termial de commande
clear



#-----------------------------------------------------------------------
#-----------------------------------------------------------------------
#                 GESTION DES DOSSIERS ET FICHIERS




racine=$(dirname "$0")  #fichier parent du programme


temp_dossier="temp"          #liste dossiers et fichiers
images_dossier="images"      #nécessaires au programme
data_dossier="data"
demo_dossier="demo"
progc_dossier="progc"

data_fichier="data.csv" 


#chemin vers les dossiers/ficiers à vérifier
temp_chemin="$racine/$temp_dossier"
data_chemin="$racine/$data_dossier/$data_fichier"
temp_chemin="$racine/$temp_dossier"
demo_chemin="$racine/$demo_dossier"
images_chemin="$racine/$images_dossier"
progc_chemin="$racine/$progc_dossier"



#vérifie l'ensemble des fichiers du programme c
#et compile si besoin
fichiersC_existence () {
if [ -f "$racine/progc/AVL_T.c" ] && [ -f "$racine/progc/AVL_S.c" ] && [ -f "$racine/progc/Makefile" ] && [ -f "$racine/progc/AVL_T.h" ] && [ -f "$racine/progc/AVL_S.h" ] && [ -f "$racine/progc/main.c" ]; then
	echo "Dossier 'progc' complet"
	echo ""
	compiler_c
else
	echo "Problèmes de fichiers dans le dossier 'progc'"
	return 0
fi
}

#compilation c
compiler_c () 
{
	make -C "$progc_chemin"
}





dossiers_existence ()                      #Vérification existence dossier
{
# fichier data : existence
if [ -f "$data_chemin" ]; 
then
    echo "Présence du <data.csv> dans dossier le 'data'"$'\n'
else
    echo "Le fichier <data.csv> n'est pas dans le dossier 'data'"
    echo "Résolvez le problème"$'\n'
    prog_quitter
fi


# dossier images : si n'existe pas, création
if [ ! -d "$images_chemin" ]; then
    mkdir "$images_dossier"
    echo "Le dossier $images_dossier est créé"$'\n'
else
    echo "Dossier $images_dossier opérationnel"$'\n'
fi



# dossier demo : si n'existe pas, création
if [ ! -d "$demo_chemin" ]; then
    mkdir "$demo_dossier"
    echo "Le dossier $demo_dossier est créé"$'\n'
else
    echo "Dossier $demo_dossier opérationnel"$'\n'
fi




# dossier temp : le créer ou le vider
if [ ! -d "$temp_chemin" ]; then
    mkdir "$temp_dossier"
    echo "Le dossier $temp_dossier est créé"$'\n'
else
    echo "Dossier $temp_dossier en nettoyage"
    rm -rf "$temp_dossier"/*   #suppresion recursive
    echo "Dossier $temp_dossier vidé"$'\n'
fi
}






#-----------------------------------------------------------------------
#-----------------------------------------------------------------------
#                       TRAITEMENTS GNUPLOT




gnuplot_d1() 
{

#mise en place minuteur + sortie image
date=$(date +"%H-%M-%Y-%S")

echo "Traitement d1 en cours"
debut_temps=$(date +%s)

#prendre colonne concernée, sort pour uniq (obligatoire)
#tout fichier .txt ressortissant mis dans demo/

cut -d ';' -f1,6 "data/$data_fichier" | sort -t ';' -k1,1 | uniq | cut -d ';' -f 2 | sort | uniq -c | sort -nr | head | awk '{print $1 ";" $2, $3}'  > temp/data_d1.dat

gnuplot_tracage -d1

fin_temps=$(date +%s)
echo "Temps d'execution : $(($fin_temps - $debut_temps)) seconde.s"$'\n'

rm temp/data_d1.dat
}



gnuplot_d2() 
{
#pareil que d1
date=$(date +"%H-%M-%Y-%S")

echo "Traitement d2 en cours"
debuy_temps=$(date +%s)

#awk créer colonne et boucle for dedans pour calcul
cut -d ";" -f5,6 "data/$data_fichier" | awk -F ';' ' {somme[$2] += $1} END {for (nom in somme) printf "%s; %.5f\n", nom, somme[nom]}' | sort -t";" -k2,2 -rn | head > temp/data_d2.dat

gnuplot_tracage -d2


fin_temps=$(date +%s)
echo "Temps d'execution : $(($fin_temps - $debut_temps)) seconde.s"$'\n'

rm temp/data_d2.dat
}





gnuplot_l() 
{
date=$(date +"%H-%M-%Y-%S")

echo "Traitement l en cours"
debut_temps=$(date +%s)

#pareil précedemment, mais colonnes prises différentes
cut -d ';' -f1,5 "data/$data_fichier" | awk -F ';' '{noms[$1]++; distances[$1]+=$2} END {for (nom in noms) print nom ";" distances[nom]}' |sort -t ';' -k2,2 -rn | head > temp/data_l.dat

gnuplot_tracage -l

fin_temps=$(date +%s)
echo "Temps d'execution : $(($fin_temps - $debut_temps)) seconde.s"$'\n'

rm temp/data_l.dat
}



gnuplot_t ()
{
#idem
date=$(date +"%H-%M-%Y-%S")

echo "Traitement t en cours"
debut_temps=$(date +%s)


tail temp/data_t.dat
gnuplot_tracage -t

fin_temps=$(date +%s)
echo "Temps d'execution : ($efin_temps - $debut_temps) seconde.s "

rm temp/data_t.dat
}



gnuplot_s ()
{
#idem
date=$(date +"%H-%M-%Y-%S")


echo "Traitement s en cours"
debut_temps=$(date +%s)

gnuplot_tracage -s

fin_temps=$(date +%s)
echo "Temps d'execution : ($fin_temps - $debut_temps) seconde.s "

rm temp/data_s.dat
}





gnuplot_tracage()
{
#un argument est requis pour faire fonctionner fonction
if [ "$#" -ne 1 ]; 
then
	echo "Usage: gnuplot_tracage <data.dat>"
        exit 1
fi

case "$1" in
                       
        -d1)

echo "Tracage en cours : -d1"

#convert necessaire pour rotation 90 (pasq natif gnuplot)
#histogramme simple sans problemes
gnuplot << EOF

set terminal pngcairo enhanced font 'Arial,12' size 1200,1200
set output 'images/d1_${date}_${nom}.png'
set datafile separator ";"

set style data histograms
set style fill solid border -1

set xlabel "DRIVER NAMES" 
set ylabel "option -d1 : Nb routes = f(Driver)" 
set y2label "NB ROUTES"

set ytics right
set xtics rotate by 90
set ytics rotate by 90

set xtics offset 0,-9
set bmargin 10

set boxwidth 0.8 relative
set yrange [0:250]
set style line 1 lc rgb '#c79fef' lt 1 lw 2
set style fill solid noborder

plot 'temp/data_d1.dat' using 1:xtic(2)  with boxes linestyle 1 notitle

EOF

convert images/d1_${date}_${nom}.png -rotate 90 images/d1_${date}_${nom}.png

echo 'Tracage enregistré sous : 'images/d1_${date}_${nom}.png' '
    
     ;;
     
        -d2)
#idem d1
echo "Tracage en cours : -d2"

gnuplot << EOF

set terminal pngcairo enhanced font 'Arial,12' size 1200,1200
set output 'images/d2_${date}_${nom}.png'
set datafile separator ";"

set style data histograms
set style fill solid border -1

set xlabel "DRIVER NAMES" 
set ylabel "option -d2 : Distance = f(Driver)" 
set y2label "DISTANCE (km)"

set xtics rotate by 90
set ytics rotate by 90

set xtics offset 0,-9
set bmargin 10


set boxwidth 0.8 relative
set yrange [0:160000]
set style line 1 lc rgb '#2ecc71' lt 1 lw 2
set style fill solid noborder

plot 'temp/data_d2.dat' using 2:xtic(1)  with boxes linestyle 1 notitle

EOF

convert images/d2_${date}_${nom}.png -rotate 90 images/d2_${date}_${nom}.png

echo 'Tracage enregistré sous : 'images/d2_${date}_${nom}.png' '

     ;;      
              
       -l)

echo "Tracage en cours : l"
#trivial
gnuplot << EOF

set terminal pngcairo enhanced font 'Arial,12' size 1000,800
set output 'images/l_${date}_${nom}.png'
set datafile separator ";"

set style data histograms
set style fill solid border -1

set title "option -l : Distance = f(Route)" 
set xlabel "ROUTE ID" 
set ylabel "DISTANCE (Km)" 

set boxwidth 0.9 relative
set yrange [0:3000]
set style line 1 lc rgb '#40e0d0' lt 1 lw 2
set style fill solid noborder

plot 'temp/data_l.dat' using 2:xtic(1)  with boxes linestyle 1 notitle

EOF


echo 'Tracage enregistré sous : 'images/l_${date}_${nom}.png' '
      
     ;;
     
        -t)

echo "Tracage en cours : -t"
# 'histogram cluster' necessaire
#pour afficher deux colonnes espacées

gnuplot << EOF

set terminal pngcairo enhanced font 'Arial,12' size 1200,800
set output "images/t_${date}_${nom}.png"
set datafile separator ";"

set style data histogram
#set style fill solid border -1
set style histogram cluster gap 1
set style fill solid 
set grid ytics

set title "option -t : Nb routes = f(Towns)" 
set xlabel "TOWN NAMES" 
set ylabel "NB ROUTES" 



set boxwidth 1.5
set yrange [0:3500]


set style line 1 lc rgb '#87CEEB' lt 1 lw 2
set style line 2 lc rgb '#4169E1' lt 1 lw 2

plot 'temp/data_t.dat' using 2:xtic(1)  title 'Total routes' ,  \
    'temp/data_t.dat' using 3  title 'First Town'

EOF


echo 'Tracage enregistré sous : 'images/t_${date}_${nom}.png''         
           
           ;;
       
       -s)

echo "Tracage en cours : -s"
#tracer les lignes max, min, moyenne,
#faire 'filledcurves' entre max et min
#abscisse plot par rapport à suite nombres
#et non valeurs mis en abscisse (routeId)
        

gnuplot << EOF

set terminal pngcairo enhanced font 'Arial,12' size 1500,1200
set output 'images/s_${date}_${nom}.png'
set datafile separator ";"

set style data histograms
set style fill solid border -1

set title "option -s : Distance= f(Route)" 
set xlabel "ROUTE ID" 
set ylabel "DISTANCE (Km)" 

set yrange [0:1000]
set xtics rotate by 45 offset 0, -2
set bmargin 4


plot 'temp/data_s.dat' using 1:4:xtic(2) with lines lc rgb "purple" lw 2 title 'Distance Average (Km)', \
     'temp/data_s.dat' using 1:5 with lines lc rgb "blue" lw 2 title 'Distance Max/Min (Km)', \
     'temp/data_s.dat' using 1:3 with lines lc rgb "blue" lw 2 notitle, \
     'temp/data_s.dat' using 1:3:5 with filledcurves lc "skyblue" fs transparent solid 0.5 notitle
EOF

echo 'Tracage enregistré sous : 'images/s_${date}_${nom}.png' '
  
        
        ;;
        
        *)
            echo "Argument non valide : $1"
            montrer_aide
	    ;;
esac

}



#-----------------------------------------------------------------------
#-----------------------------------------------------------------------
#               FONCTION GESTION PROGRAMME




#explication du programme
montrer_aide() 
{

echo "Usage: bash main.sh <arg1> <arg2> <arg3> <arg4> <arg5> <arg6> <arg7>"$'\n'
echo "Liste des arguments disponibles :"$'\n'
echo "option -d1 : Conducteurs avec le plus de trajets "$'\n'
echo "option -d2 : Conducteurs et la plus grande distance "$'\n'
echo "option -l : Les 10 trajets les plus longs "$'\n'
echo "option -t : Les 10 villes les plus traversées "$'\n'
echo "option -s : Statistiques sur les étapes "$'\n'
echo "option -h : Afficher l'aide"$'\n'
echo "option -bibliographie : Aides à la création du projet sourcées"$'\n'

return 1

}





verif_nom() 
{

#pseudo de [1;25] caractères
#pas d'espace, chaine de caractères
#permet de personnaliser nom images
#pour plusieurs utilisations


if [ "$#" -ne 1 ]; then
        echo "Usage: verif_nom <nom>"
        echo "1 seul nom requis"
	read -p "Entrez un nom d'utilisateur : " nom
        verif_nom "$nom"
	return 0
fi

nom="$1"

if [[ -z "$nom" || ! "$nom" =~ ^[[:alnum:]_]+$ ]]; then #=~ ^[[:alnum:]_]+$ : par chat-openai                                           
    echo "Erreur : le nom doit être une chaine de caractères sans espace"  #verifier si présence seulement caractères alphanumériques
    read -p "Entrez un nom d'utilisateur : " nom
    verif_nom "$nom"
    return 0
fi

longueur=${#nom}

if ((longueur < 1 || longueur > 25)); then
   echo "Erreur : le nom doit faire entre 1 et 25 caractères"
   read -p "Entrez un nom d'utilisateur : " nom
   verif_nom "$nom"
   return 0
fi

return 0

}




verif_arg () 
{

echo "Vérification des arguments passés en paramètres"
#liste des arguments
prog_arguments=(-d1 -d2 -l -s -t -h -bibliographie)
arguments_finaux=()


#vérification des arguments au lancement
#du programme :
#chaque argument peut être mis une fois
#soit un total de 6 disponibles

#si 0 argument rentré : sortie
if  [ "$#" -eq 0 ]; then
    echo "Aucun argument spécifié"$'\n'
    montrer_aide
    prog_quitter
    exit 1

#si plus de 7 arguments rentrés : sortie
elif [ "$#" -gt 7 ]; then
    echo "Erreur: nombre d'arguments incorrect"$'\n'
    montrer_aide
    prog_quitter
    exit 1
fi

#boucle pour filtrer arguments
for arg in "$@"; 
	do
	for valid_arg in "${prog_arguments[@]}"; 
		do
		if [ "$arg" == "$valid_arg" ]; then
                	arguments_finaux+=("$arg")
                break
       	        fi
	done
done

}


affich_arg () 
{

echo "Nombre total d'arguments : $#"$'\n'
echo "Liste des arguments :"
for arg in "${arguments_finaux[@]}"; do
        echo "$arg"
    done
echo ""

}



#compteur de 15 secondes
#avant fermeture programme
#à faire varier si besoins
prog_quitter() 
{

for ((i = 1; i <= 15; i++)); 
do
	echo $i
	sleep 1
done

clear

echo "CY Truck : fin"
exit 0

}



montrer_bibliographie () 
{
echo "Liste des sources pour le programme :"$'\n'
echo "Pour les traitements Bash"
echo "https://www.cyberciti.biz/faq/bash-scripting-using-awk/"
echo "https://www.shellunix.com/awk.html"
echo "https://www.it-connect.fr/trier-les-lignes-en-double-avec-la-commande-uniq-sous-linux/"$'\n'
echo "https://forum.ubuntu-fr.org/viewtopic.php?id=2036531"
echo "https://askubuntu.com/questions/724338/how-to-set-lc-numeric-to-english-permanently"
echo "Bash : gnuplot"
echo "https://askubuntu.com/questions/701986/how-to-execute-commands-in-gnuplot-using-shell-script"
echo "http://www.phyast.pitt.edu/~zov1/gnuplot/html/histogram.html"
echo "http://gnuplot-tricks.blogspot.com/2009/10/turning-of-histogram.html"$'\n'
echo "Pour la partie C :"
echo "https://koor.fr/C/cstdlib/qsort.wp"
echo ""
echo "Pour le MakeFile :"
echo "https://linuxpedia.fr/doku.php/dev/makefile"
echo ""
}

verif_logiciel () {


#vérification présence gnuplot sur appareil
#sinon installation
if ! command -v gnuplot &> /dev/null; then #teste si gnuplot
        echo "Gnuplot non installé"
        # Installation sur un système basé sur Debian
        sudo apt-get update
        sudo apt-get install gnuplot        
else 
   echo "Gnuplot installé sur l'appareil"
fi


#vérification présence ImageMagick sur appareil, 
#sinon installation
if ! command -v convert &> /dev/null; then #teste si commande convert presence
    echo "ImageMagick non installé"        
    echo "Installation en cours"

    # Installation sur un système basé sur Debian
    sudo apt-get update
    sudo apt-get install -y imagemagick
else 
    echo "ImageMagick installé sur l'appareil"
fi
echo ""

}


#--------------------------------------------------------------------
#--------------------------------------------------------------------
#                  MAIN PROGRAM


echo "---------------------------------------"$'\n'

verif_arg "$@"
verif_logiciel
echo ""

echo "---------------------------------------"$'\n'

read -p "Entrez un nom d'utilisateur : " nom
verif_nom "$nom"
echo ""

echo "---------------------------------------"$'\n'

echo "Vérification de la présence des outils nécessaires"
echo "au bon fonctionnement du programme :"$'\n'

fichiersC_existence 
dossiers_existence

echo "---------------------------------------"$'\n'


affich_arg "${arguments_finaux[@]}"



echo "---------------------------------------"$'\n'



for arg in "${arguments_finaux[@]}"; do
	if [ "$arg" == "-h" ]; then
		show_help
		echo "---------------------------------------"$'\n'
	fi
done






for arg in "${arguments_finaux[@]}"; do
case "$arg" in
	
	-d1)
	  gnuplot_d1
	  
	  echo "---------------------------------------"$'\n'
	  ;;
	
	-d2)
	 gnuplot_d2
	 echo "---------------------------------------"$'\n'
	 ;;
	
	-l)
	 gnuplot_l
	 echo "---------------------------------------"$'\n'
	 ;;
	
	-t)
	./ALVT
         mv "$racine/progc/data_t.dat" "$racine/temp" 
         gnuplot_t
	 
         echo "---------------------------------------"$'\n'
	 ;;
	
	-s)
	 ./AVLS
          mv "$racine/progc/data_s.dat" "$racine/temp" 
	  gnuplot_s
	
         echo "---------------------------------------"$'\n'
	 ;;
	
	
	-bibliographie)
	 montrer_bibliographie
	 echo "---------------------------------------"$'\n'
	 ;;
	
	-h)
	;;
	
	*)
         echo "$arg : Argument non reconnu"
	 echo "Fonctions de vérifications à régler"$'\n'
	 echo "---------------------------------------"$'\n'
	 ;;
esac
done

echo "---------------------------------------"$'\n'

echo "Fin d'execution du programme"
prog_quitter



