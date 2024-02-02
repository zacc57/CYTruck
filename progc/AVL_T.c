#include<stdio.h>
#include<stdlib.h>
#include<string.h>
#include <sys/param.h>
#include <stddef.h>

typedef struct AVL{
    struct AVL* FD;
    struct AVL* FG;
    char* ville;
    int NbrTraverse;
    int NbrDepart;
    int Hauteur;
} AVL;

AVL* NewAVL1(char* ville, short  depart){
    AVL* pNew=malloc(sizeof(AVL)); //possible remplacement par stlern
    if (pNew==NULL){
      exit(1);
    }
    pNew->ville=strdup(ville);
    if (depart==1){
        pNew->NbrDepart=1;
        pNew->NbrTraverse=0;
    }
    else{
        pNew->NbrDepart=0;
        pNew->NbrTraverse=1;
    }
    pNew->FD=NULL;
    pNew->FG=NULL;
    pNew->Hauteur=1;
    return pNew;
}

AVL* NewAVL2(AVL* element){
    AVL* pNew=malloc(sizeof(AVL)); //possible remplacement par stlern
    if (pNew==NULL){
      exit(1);
    }
    pNew->ville=strdup(element->ville);
    pNew->NbrDepart=element->NbrDepart;
    pNew->NbrTraverse=element->NbrTraverse;
    pNew->FD=NULL;
    pNew->FG=NULL;
    pNew->Hauteur=1;
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

AVL* insertElementAVL1(AVL* element, char* ville, short depart){
    if (element==NULL){
        return NewAVL1(ville, depart);
    }
    int compareResult = strcmp(ville, element->ville);
    if (compareResult<0){
        element->FG=insertElementAVL1(element->FG, ville, depart);
    }
    else if (compareResult>0){
        element->FD=insertElementAVL1(element->FD, ville, depart);
    }
    else {
        if (depart==1){
            element->NbrDepart++;
        }
        else{
            element->NbrTraverse++;
        }
        return element;
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

AVL* insertElementABR2(AVL* element, AVL* pNew){
    if (element==NULL){
        return NewAVL2(pNew);
    }

    if (pNew->NbrTraverse<element->NbrTraverse){
        element->FG=insertElementABR2(element->FG, pNew);
    }
    else if (pNew->NbrTraverse>=element->NbrTraverse){
        element->FD=insertElementABR2(element->FD, pNew);
    }

    element->Hauteur=Hauteur(element);
    return element;
}

AVL* creationABR2(AVL* element1,AVL* element2){
    if(element1==NULL){
        return 0;
    }
    element2=insertElementABR2(element2,element1);
    creationABR2(element1->FD,element2);
    creationABR2(element1->FG,element2);
    return element2;
}

AVL* transformationAVL(AVL* element){
    while(fequilibre(element)<=-2 && fequilibre(element)>=-2){
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
    }
    return element;
}



void Affichage(AVL* element){ //affiche et supprime le dernier élément
      if(element==NULL){
          return;
      }
      Affichage(element->FD);
      printf ("%s;%d;%d\n", element->ville,element->NbrTraverse,element->NbrDepart);
      Affichage(element->FG);
}

void FreeAVL(AVL* element) {
    if (element != NULL) {
        FreeAVL(element->FG);
        FreeAVL(element->FD);
        free(element->ville);
        free(element);
    }
}

int main(){
      AVL* element1=NULL;
      AVL* element2=NULL;
      char* line;
      size_t len=0;
      ssize_t read;
      FILE* FD= fopen("data/data.csv", "r");
      FILE* sortieFD = fopen("data_t.dat", "w");
      if (FD==NULL || sortieFD==NULL ){
          exit(1);
      }
      while ((read = getline(&line, &len, FD)) != -1) {
          char* strline= strtok(line,";");
          strline=strtok(NULL,";");
          int depart=atol(strline);
          strline=strtok(NULL,";");
          if (depart==1){
              char* ville=strline;
              element1=insertElementAVL1(element1,ville,1);
          }
          strline=strtok(NULL,";");
          char* ville=strline;
          element1=insertElementAVL1(element1,ville,0);
      }
      
     fclose(sortieFD);
    fclose(FD);
     element2=creationABR2(element1,element2);
      element2=transformationAVL(element2);
      Affichage(element2);
      FreeAVL(element1);
      FreeAVL(element2);
      return 0;
}



