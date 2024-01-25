#!/bin/bash


#plus de visibilité sur le termial de commande
clear



#-----------------------------------------------------------------------
#-----------------------------------------------------------------------
#                 GESTION DES DOSSIERS ET FICHIERS




root=$(dirname "$0")  #fichier parent du programme


temp_folder="temp"          #liste dossiers et fichiers
images_folder="images"      #nécessaires au programme
data_folder="data"
demo_folder="demo"
progc_folder="progc"

data_file="data.csv" 


#chemin vers les dossiers/ficiers à vérifier
temp_root="$root/$temp_folder"
data_root="$root/$data_folder/$data_file"
temp_root="$root/$temp_folder"
demo_root="$root/$demo_folder"
images_root="$root/$images_folder"






excc_filec ()                       #vérifier l'existence et la compilation
{                                   #de l'executable C

make -C $root/$progc_folder
echo "test"

}




folder_existence ()                      #Vérification existence dossier
{


# fichier data : existence
if [ -f "$data_root" ]; 
then
    echo "Le fichier <data.csv> dans dossier 'data'"$'\n'
else
    echo "Fichier <data.csv> n'est pas dans le dossier 'data'"
    echo "Résolvez le problème"$'\n'
fi


# dossier images : si n'existe pas, création
if [ ! -d "$images_root" ];
 then
    mkdir "$images_folder"
    echo "Le dossier $images_folder est créé"$'\n'
else
   echo "Dossier $images_folder opérationnel"$'\n'
fi



# dossier demo : si n'existe pas, création
if [ ! -d "$demo_root" ];
 then
    mkdir "$demo_folder"
    echo "Le dossier $demo_folder est créé"$'\n'
else
   echo "Dossier $demo_folder opérationnel"$'\n'
fi




# dossier temp : le créer ou le vider
if [ ! -d "$temp_root" ]; 
then
    mkdir "$temp_folder"
    echo "Le dossier $temp_folder est créé"$'\n'
else
  echo "Dossier $temp_folder en nettoyage"
  rm -rf "$temp_folder"/*
  echo "Dossier $temp_folder vidé"$'\n'
fi



# progc : présence intégralité fichiers nécessaires




}






#-----------------------------------------------------------------------
#-----------------------------------------------------------------------
#                       TRAITEMENTS GNUPLOT








gnuplot_d1() 
{

#mise en place timer + sortie image
date=$(date +"%H-%M-%Y-%S")
output_png="images/d1_${date}_${username}.png"
 
echo "Traitement d1 en cours"
start_time=$(date +%s)

#prendre colonne concernée, sort pour uniq (obligatoire)
#tout fichier .txt ressortissant mis dans demo/

cut -d ';' -f1,6 "$data_file" | sort -t ';' -k1,1 | uniq | cut -d ';' -f 2 | sort | uniq -c | sort -nr | head | awk -F ';' '{printf "%s;%s%s\n", $1, $2, $3}' > demo/data_d1.dat

gnuplot_tracage -d1

end_time=$(date +%s)
echo "Temps d'execution : $(($end_time - $start_time)) seconde.s"$'\n'


}



gnuplot_d2() 
{

date=$(date +"%H-%M-%Y-%S")
output_png="images/d2_${date}_${username}.png"


echo "Traitement d2 en cours"
start_time=$(date +%s)

#awk créer colonne et boucle for dedans pour calcul
cut -d ";" -f5,6 "$data_file" | awk -F ";" '{noms[$2]++;distances[$2]+=$1} END {for (i in noms) print i ";" distances[i]}' | sort -t";" -k2,2 -rn | head > demo/data_d2.dat

gnuplot_tracage -d2


end_time=$(date +%s)
echo "Temps d'execution : $(($end_time - $start_time)) seconde.s"$'\n'


}





gnuplot_l() 
{


date=$(date +"%H-%M-%Y-%S")
output_png="images/l_${date}_${username}.png"

echo "Traitement l en cours"
start_time=$(date +%s)

#pareil précedemment, mais colonnes prises différentes
cut -d ';' -f1,5 "$data_file" | awk -F ';' '{noms[$1]++; distances[$1]+=$2} END {for (nom in noms) print nom ";" distances[nom]}' |sort -t ';' -k2,2 -rn | head > demo/data_l.dat



gnuplot_tracage -l


end_time=$(date +%s)
eog images/l_${date}_${username}.png
echo "Temps d'execution : $(($end_time - $start_time)) seconde.s"$'\n'

}



gnuplot_t ()
{

date=$(date +"%H-%M-%Y-%S")
output_png="images/t_${date}_${username}.png"



echo "Traitement t en cours"
start_time=$(date +%s)

gnuplot_tracage -t

end_time=$(date +%s)
echo "Temps d'execution : ($end_time - $start_time) seconde.s "


}



gnuplot_s ()
{

date=$(date +"%H-%M-%Y-%S")
output_png="images/s_${date}_${username}.png"


echo "Traitement s en cours"
start_time=$(date +%s)

gnuplot_tracage -s

end_time=$(date +%s)
echo "Temps d'execution : ($end_time - $start_time) seconde.s "


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

gnuplot << EOF

set terminal pngcairo enhanced font 'Arial,12' size 1200,1200
set output 'images/d1_${date}_${username}.png'
set datafile separator ";"

set style data histograms
set style fill solid border -1

set xlabel "DRIVER NAMES" 
set ylabel "option -d1 : Nb routes = f(Driver)" 
set y2label "NB ROUTES"

set ytics right
set xtics rotate by 90
set ytics rotate by 90


set boxwidth 0.8 relative
set yrange [0:250]
set style line 1 lc rgb '#c79fef' lt 1 lw 2
set style fill solid noborder

plot 'demo/data_d1.dat' using 2:xtic(1)  with boxes linestyle 1 notitle

EOF

convert images/d1_${date}_${username}.png -rotate 90 images/d1_${date}_${username}.png

echo 'Tracage enregistré sous : 'images/d1_${date}_${username}.png' '
     ;;
   
   
        -d2)

echo "Tracage en cours : -d2"

gnuplot << EOF

set terminal pngcairo enhanced font 'Arial,12' size 1200,1200
set output 'images/d2_${date}_${username}.png'
set datafile separator ";"

set style data histograms
set style fill solid border -1

set xlabel "DRIVER NAMES" 
set ylabel "option -d2 : Distance = f(Driver)" 
set y2label "DISTANCE (km)"

set xtics rotate by 90
set ytics rotate by 90


set boxwidth 0.8 relative
set yrange [0:160000]
set style line 1 lc rgb '#2ecc71' lt 1 lw 2
set style fill solid noborder

plot 'demo/data_d2.dat' using 2:xtic(1)  with boxes linestyle 1 notitle

EOF

convert images/d2_${date}_${username}.png -rotate 90 images/d2_${date}_${username}.png

echo 'Tracage enregistré sous : 'images/d2_${date}_${username}.png' '

     ;;      
       
       
       -l)

echo "Tracage en cours : l"

gnuplot << EOF

set terminal pngcairo enhanced font 'Arial,12' size 1000,800
set output 'images/l_${date}_${username}.png'
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

plot 'demo/data_l.dat' using 2:xtic(1)  with boxes linestyle 1 notitle

EOF


echo 'Tracage enregistré sous : 'images/l_${date}_${username}.png' '
  
     
     ;;







        
        
        
        
        -t)

echo "Tracage en cours : -t"
           
gnuplot << EOF

set terminal pngcairo enhanced font 'Arial,12' size 1200,800
set output 'images/t_${date}_${username}.png'
set datafile separator ";"

set style data histograms
set style fill solid border -1

set title "option -t : Nb routes = f(Towns)" 
set xlabel "TOWN NAMES" 
set ylabel "NB ROUTES" 

set boxwidth 0.5 relative
set yrange [0:3500]

set style line 1 lc rgb '#87CEEB' lt 1 lw 2
set style line 2 lc rgb '#4169E1' lt 1 lw 2
set style fill solid noborder

plot 'demo/data_t.dat' using 2:xtic(1)  with boxes linestyle 1 title 'Total routes', \
     'demo/data_t.dat' using 3:xtic(1)  with boxes linestyle 2 title 'First Town'


EOF

echo 'Tracage enregistré sous : 'images/t_${date}_${username}.png' '
  

           
           
           
           
           
           ;;
        -s)

echo "Tracage en cours : -s"

        
gnuplot << EOF

set terminal pngcairo enhanced font 'Arial,12' size 1200,800
set output 'images/s_${date}_${username}.png'
set datafile separator ";"

set style data histograms
set style fill solid border -1

set title "option -s : Distance= f(Route)" 
set xlabel "ROUTE ID" 
set ylabel "DISTANCE (Km)" 

set yrange [0:1000]

plot 'demo/data_s.dat' using 1:3:5 with filledcurves closed lc rgb "blue" title 'Distances Max/min (Km)' ,\
'demo/data_s.dat' using 1:4 with lines lc rgb "purple" lw 2 title 'Distance Average (Km)'


EOF

echo 'Tracage enregistré sous : 'images/s_${date}_${username}.png' '
  
        
        ;;
        *)
            echo " Argument non valide : $1"
            show_help 
	    ;;
    esac

}



#-----------------------------------------------------------------------
#-----------------------------------------------------------------------
#               FONCTION GESTION PROGRAMME





show_help() 
{

echo "Usage: bash main.sh <arg1> <arg2> <arg3> <arg4> <arg5> <arg6>"$'\n'
echo "Arguments :"$'\n'
echo "option -d1 : Conducteurs avec le plus de trajets "$'\n'
echo "option -d2 : Conducteurs et la plus grande distance: "$'\n'
echo "option -l : Les 10 trajets les plus longs "$'\n'
echo "option -t :Les 10 villes les plus traversées "$'\n'
echo "option -s : Statistiques sur les étapes "$'\n'
echo "option -h : afficher l'aide"$'\n'

return 1

}





username_check() 
{

#pseudo de [1;25] caractères
#pas d'espace, chaine de caractères
#permet de personnaliser nom images
#pour plusieurs utilisations


if [ "$#" -ne 1 ]; 
 then
        echo "Usage: username_check <nom>"
        echo "1 seul nom requis"
	exit 1
fi

username="$1"

if [[ -z "$username" || ! "$username" =~ ^[[:alnum:]_]+$ ]]; 
then
    echo "Erreur : le nom doit être une chaine de caractères sans espace"
    return 1
fi

length=${#username}

if ((length < 1 || length > 25)); 
then
  echo "Erreur : le nom doit faire entre 1 et 25 caractères"
  return 1
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

#si 0 argument rentré : exit
if  [ "$#" -eq 0 ]; 
then
    echo "Aucun argument spécifié"$'\n'
    show_help
    prog_exit
    exit 1

#si plus de 7 arguments rentrés : exit
elif [ "$#" -gt 7 ]; 
then
    echo "Erreur: nombre d'arguments incorrect"$'\n'
    show_help
    prog_exit
    exit 1
fi


for arg in "$@"; 
do
for valid_arg in "${prog_arguments[@]}"; 
do
	if [ "$arg" == "$valid_arg" ]; 
	then
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



#compteur de 10 secondes
#avant fermeture programme

prog_exit () 
{

for ((i = 1; i <= 20; i++)); 
do
	echo $i
	sleep 1
done

clear

echo "CY Truck : fin"
exit 0

}



show_bibliographie () 
{
echo "Liste des sources pour le programme :"$'\n'
echo "Pour les traitements Bash"
echo "https://www.cyberciti.biz/faq/bash-scripting-using-awk/"
echo "https://www.shellunix.com/awk.html"
echo "https://www.it-connect.fr/trier-les-lignes-en-double-avec-la-commande-uniq-sous-linux/"$'\n'
echo "Bash : gnuplot"
echo "https://askubuntu.com/questions/701986/how-to-execute-commands-in-gnuplot-using-shell-script"
echo "http://www.phyast.pitt.edu/~zov1/gnuplot/html/histogram.html"
echo "http://gnuplot-tricks.blogspot.com/2009/10/turning-of-histogram.html"$'\n'
}

verif_logiciel () {


#vérification présence gnuplot sur appareil
#sinon installation
if ! command -v gnuplot &> /dev/null; 
then
        echo "Gnuplot non installé"
        exit 1
else 
   echo "Gnuplot installé sur l'appareil"
fi


#vérification présence ImageMagick sur appareil, 
#sinon installation
if ! command -v convert &> /dev/null; then
    echo "ImageMagick n'est pas installé" 
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

read -p "Entrez un nom d'utilisateur : " username
username_check "$username"

echo "---------------------------------------"$'\n'

echo "Vérification de la présence des outils nécessaires"
echo "au bon fonctionnement du programme"$'\n'

echo "---------------------------------------"$'\n'

excc_filec  
folder_existence

echo "---------------------------------------"$'\n'


affich_arg "${arguments_finaux[@]}"



echo "---------------------------------------"$'\n'



for arg in "${arguments_finaux[@]}"; do
if [ "$arg" == "-h" ]; 
       then
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
	 gnuplot_t
	 echo "---------------------------------------"$'\n'
	 ;;
	
	-s)
	 gnuplot_s
	 echo "---------------------------------------"$'\n'
	 ;;
	
	
	-bibliographie)
	 show_bibliographie
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
prog_exit






