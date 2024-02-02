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
        return NewAVL(ville, depart);
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
            element->NbrDepart+1;
        }
        else{
            element->NbrTraverse+1;
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

AVL* insertElementAVL2(AVL* element, AVL* pNew){
    if (element==NULL){
        return NewAVL2(pNew);
    }

    if (pNew->NbrTraverse<element->NbrTraverse){
        element->FG=insertElementAVL1(element->FG, ville, depart);
    }
    else if (pNew->NbrTraverse>element->NbrTraverse){
        element->FD=insertElementAVL1(element->FD, ville, depart);
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

void Affichage(AVL*element){
      if (element==NULL){
          return;
      }
      Affichage(element->FD);
      printf("%s ", element->ville);
      printf("%s %d;","depart->",element->NbrDepart);
      printf("%s %d\n","depart->",element->NbrTraverse);

      Affichage(element->FG);
}
int main(){
      AVL* element=NULL;
      char* line;
      size_t len=0;
      ssize_t read;
      FILE* FD= fopen("toto.txt", "r");
      if (FD==NULL){
          exit(1);
      }
      while ((read = getline(&line, &len, FD)) != -1) {
          char* strline= strtok(line,";");
          strline=strtok(NULL,";");
          int depart=atol(strline);
          strline=strtok(NULL,";");
          if (depart==1){
              char* ville=strline;
              element=insertElementAVL1(element,ville,1);
          }
          strline=strtok(NULL,";");
          char* ville=strline;
          element=insertElementAVL1(element,ville,0);
      }
      CreationAVL2(element);
      Affichage(element);
      return 0;
  }

