#include<stdio.h>
#include<stdlib.h>
#include<string.h>
#include <sys/param.h>
#include <stddef.h>



typedef struct AVL{
    struct AVL* FD;
    struct AVL* FG;
    int stepID;
    int occurence;
    int distanceMAX;
    int distanceMIN;
    int sommeDistance;
    int moyenne;
} AVL;

AVL* NewAVL1(int ID, int distance){
    AVL* pNew=malloc(sizeof(AVL)); //possible remplacement par stlern
    if (pNew==NULL){
      exit(1);
    }
    pNew->FD=NULL;
    pNew->FG=NULL;
    pNew->stepID= ID;
    pNew->occurence=1;
    pNew->sommeDistance=distance
    pNew->distanceMAX=distance;
    pNew->distanceMin=distance;
    pNew->moyenne=distance;

    return pNew;
}

AVL* NewAVL2(AVL*element){
    AVL* pNew=malloc(sizeof(AVL)); //possible remplacement par stlern
    if (pNew==NULL){
      exit(1);
    }
    pNew->FD=NULL;
    pNew->FG=NULL;
    pNew->stepID= element->stepID;
    pNew->occurence=element->occurence;
    pNew->sommeDistance=element->sommeDistance;
    pNew->distanceMAX=element->distanceMAX;
    pNew->distanceMin=element->distanceMIN;
    pNew->moyenne=element->moyenne;

    return pNew;
}
int Hauteur(AVL* element){
  int HauteurFD=0;
  int HauteurFG=0;
  if (element->FD!=NULL){
      HauteurFD=element->FD->Hauteur;
  }
  if (element->FG!=NULL){
      HauteurFG=element->FG->Hauteur;
  }
  return MAX(HauteurFG,HauteurFD)+1;
}

int fequilibre(AVL* element){
    int HauteurFD=0;
    int HauteurFG=0;
    if (element->FD!=NULL){
        HauteurFD=element->FD->Hauteur;
    }
    if (element->FG!=NULL){
        HauteurFG=element->FG->Hauteur;
    }
    return HauteurFG-HauteurFD;
}

AVL* rotationADroite(AVL*element){
    AVL* pivot=element->FG;
    element->FG=element->FG->FD;
    pivot->FD=element;
    element->Hauteur=Hauteur(element);
    pivot->Hauteur=Hauteur(element);
    return pivot;
}

AVL* rotationAGauche(AVL*element){
    AVL*pivot=element->FD;
    element->FD=element->FD->FG;
    pivot->FG=element;
    element->Hauteur=Hauteur(element);
    pivot->Hauteur=Hauteur(element);
    return pivot;
}

AVL* insertElementAVL1(AVL* element, int stepID, int distance, ){
    if (element==NULL){
        return NewAVL1(ville, depart);
    }

    if (stepID<element->stepID){
        element->FG=insertElementAVL1(element->FG, stepID, distance);
    }
    else if (stepID>element->stepID){
        element->FD=insertElementAVL1(element->FD, stepID, distance);
    }
    else {
        if (distance>elementdistanceMAX){
              element->distanceMAX=distance;
        }
        else if (distance<elementdistanceMAX){
              element->distanceMIN=distance;
        }
        element->sommeDistance=element->sommeDistance+distance;
        element->occurence++;
        element->moyenne=element->sommeDistance/element->occurence;
    }
    element->Hauteur=Hauteur(element);
    if (fequilibre(element)<=-2){
        if (fequilibre(element->FD)>0){
            element->FD=rotationADroite(element->FD);
        }
        element=rotationAGauche(element);
    }
    else if (fequilibre(element)>=2){
        if (fequilibre(element->FG)<0){
            element->FG=rotationAGauche(element->FG);
        }
        element=rotationADroite(element);
    }
    return element;
}

VL* insertElementABR2(AVL* element, AVL* pNew){
    if (element==NULL){
        return NewAVL2(pNew);
    }

    if (pNew->distanceMAX-pNew->distanceMIN<element->distanceMAX-element->distanceMIN){
        element->FG=insertElementABR2(element->FG, pNew);
    }
    else if (pNew->distanceMAX-pNew->distanceMIN>=element->distanceMAX-element->distanceMIN){
        element->FD=insertElementABR2(element->FD, pNew);
    }

    element->Hauteur=Hauteur(element);
    return element;
}

void Affichage(AVL* element){ //affiche et supprime le dernier élément
      if(element==NULL){
          return;
      }
      Affichage(element->FD);
      printf ("%s;%d;%d\n", element->moyenne,element->distanceMIN,element->distanceMAX);
      Affichage(element->FG);
}

void FreeAVL(AVL* element) {
    if (element != NULL) {
        FreeAVL(element->FG);
        FreeAVL(element->FD);
        free(element);
    }
}

int main(){
      AVL* element1=NULL;
      AVL* element2=NULL;
      char* line;
      size_t len=0;
      ssize_t read;
      FILE* FD= fopen("data.csv", "r");
      if (FD==NULL){
          exit(1);
      }
      while ((read = getline(&line, &len, FD)) != -1) {
          char* strline= strtok(line,";");
          int StepID=atol(strline);
          strline=strtok(NULL,";");
          strline=strtok(NULL,";");
          strline=strtok(NULL,";");
          int distance=atol(strline);
          element1=insertElementAVL1(StepID,distance);
      }
      element2=creationABR2(element1,element2);
      element2=transformationAVL(element2);
      Affichage(element2);
      FreeAVL(element1);
      FreeAVL(element2);
      return 0;
}
