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
    echo "Le fichier data existe"$'\n'
else
    echo "Le fichier data n'existe pas"
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
cut -d ';' -f1,6 "$data_file" | sort -t ';' -k1,1 | uniq | cut -d ';' -f 2 | sort | uniq -c| sort -nr | head > demo/data_d1.txt 


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
cut -d ";" -f5,6 "$data_file" | awk -F ";" '{noms[$2]++;distances[$2]+=$1} END {for (i in noms) print i ";" distances[i]}' | sort -t";" -k2,2 -rn | head > demo/data_d2.txt

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
cut -d ';' -f1,5 "$data_file" | awk -F ';' '{noms[$1]++; distances[$1]+=$2} END {for (nom in noms) print nom ";" distances[nom]}' |sort -t ';' -k2,2 -rn | head > demo/data_l.txt



gnuplot_tracage -l


end_time=$(date +%s)
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

#vérification présence gnuplot sur appareil
if ! command -v gnuplot &> /dev/null; 
then
        echo "Gnuplot non installé"
        exit 1
fi


#un argument est requis pour faire fonctionner fonction
 if [ "$#" -ne 1 ]; 
 then
        echo "Usage: gnu_tracer <data.txt>"
        exit 1
fi


case "$1" in
        
        
        
        -d1)
            echo "L'argument est 'valeur1'."

	    #on prend le fichier data
local tab_data="$1"
cat $tab_data

#commandes gnuplot reunies en 1 bloc
gnuplot <<- EOP

set term png
set output "$output_png"

set style fill solid
set boxwidth 0.5


set xlabel "NB ROUTES"
set ylabel "DRIVER NAMES"
set title "Option -d1 : Nb routes = f(Driver)"
  
 set datafile separator " "  
  
plot "$tab_data" using 4:5

EOP

#enregistré dans fichiers images
echo 'Tracage enregistré sous : '$output_png' '
	    
     ;;
        



        
                
        -d2)
            echo "L'argument est 'valeur2'."

tab_data="$1"
cat $tab_data

gnuplot <<- EOP

set term png
set output "$output_png"

set style fill solid
set boxwidth 0.5


set xlabel "NB ROUTES"
set ylabel "DRIVER NAMES"
set title "Option -d1 : Nb routes = f(Driver)"
  
 set datafile separator " "  
  
plot "$tab_data" using 1:2


EOP


echo 'Tracage enregistré sous : '$output_png' '

     
	    ;;



  
       
       
       
       
       
       
       -l)
            echo "L'argument est 'valeur2'."
            
	    
   tab_data="$1"
cat $tab_data

gnuplot <<- EOP

set term png
set output "$output_png"

set style fill solid
set boxwidth 0.5


set xlabel "NB ROUTES"
set ylabel "DRIVER NAMES"
set title "Option -d1 : Nb routes = f(Driver)"
  
set datafile separator ";"  
set yrange [] reverse 
 
plot "$tab_data" using 1:2 with points title "Graphique"


EOP


echo 'Tracage enregistré sous : '$output_png' '
  
     
     ;;







        
        
        
        
        -t)
            echo "L'argument est 'valeur2'."
            ;;
        -s)
            echo "L'argument est 'valeur2'."
            ;;
        *)
            echo "L'argument est une valeur inattendue : $1."
            ;;
    esac



if command -v xdg-open &> /dev/null; 
then
        xdg-open  "$output_png"
    else
        echo "Ouverture impossible, essayez manuellement"
fi


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
    echo "Erreur : le nom est une chaine de caractères sans espace"
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

#vérification des arguments au lancement
#du programme :
#chaque argument peut être mis une fois
#soit un total de 6 disponibles

arg_uniq=($(printf "%s\n" "$@" | sort -u))


if  [ "$#" -eq 0 ]; 
then
    echo "Aucun argument spécifié"$'\n'
    show_help
    prog_exit
    exit 1

elif [ "$#" -gt 6 ]; 
then
    echo "Erreur: nombre d'arguments incorrect"$'\n'
    show_help
    prog_exit
    exit 1

elif [ "${#arg_uniq[@]}" -ne "$#" ]; 
then
    echo "Erreur: chaque arguments doit être unique"$'\n'
    show_help
    prog_exit
    exit 1
else
   echo "Argument.s valide.s"$'\n'
fi



}


#compteur de 10 secondes
#avant fermeture programme

prog_exit () 
{

for ((i = 1; i <= 10; i++)); 
do
	echo $i
	sleep 1
done

clear

echo "CY Truck : fin"
exit 0

}






#--------------------------------------------------------------------
#--------------------------------------------------------------------
#                  MAIN PROGRAM






echo "---------------------------------------"$'\n'

verif_arg "$@"

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

echo "Nombre total d'arguments : $#"$'\n'

echo "Liste des arguments :"$'\n'
for arg in "$@"; 
    echo "$arg"$'\n'
done


echo "---------------------------------------"$'\n'





for ((i=1; i<=$#; i++)); 
do
    if [ "${!i}" = "-h" ]; 
    then       
       echo "argument -h"$'\n'
       show_help
       echo "---------------------------------------"$'\n'
       set -- "${@:1:i-1}" "${@:i+1:$#}"
    break
fi
done


for arg in "$@"; do
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
	
	*)
         echo "Argument non reconnu: $arg"
	 echo "Argument ignoré"$'\n'
	 echo "---------------------------------------"$'\n'
	 ;;
esac
done

echo "---------------------------------------"$'\n'
prog_exit


