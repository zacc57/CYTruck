#include <stdio.h>
#include <stdlib.h>
#include <string.h>



typedef struct AVL{
    AVL* FD;
    AVL* FG;
    char** ville;
    int NbrTraverse;
    int NbrDepart;
} AVL;

AVL* NewAVL(Char** a, ){
    AVL* pNew=Malloc(sizeof(AVL)); //possible remplacement par stlern
    if (pNew=NULL){
      exit(1);
    }
    pNew->ville=a*;
    pNew->NbrTRaverse=0;
    pNew->NbrDepart=0;
    pNew->FD=NULL;
    pNEw->FG=NULL;
    return pNew;
}

int Main{

    Fonction arbre vide ?
    While (a*!="\0"){
      char a* = scan la ville;
      short b = scanf(etape=1)// b=1 si c'est un dÃ©part 0 sinon
      TrierAVL1(a*, *pHead, b)
      equilibreAVL
      ligne suivante
    }


  AVL* TrierAVL1(char* a, AVL* pAVL, short b){
        if (a*<pAVL->ville){
            if (pAVL->FG=NULL){
                AVL* pNew=AddAVL1(*a, b);
            }
            else{
                TrierAVL1(*a, *FG, b);
            }
        }
        else if (a*>pAVL->ville){
            if (pAVL->FD=NULL){
                AVL* pNew=AddAVL1(*a, b);
            }
            else{
                TrierAVL1(*a, *FD, b);
            }
        }
        else {
            pAVL->NbrTraverse++;
            if (b=1){
                pNew->NbrDepart++;
            }
        }
        return 0;
  }

  AVL* AddAVL1(char* a, short b){

      AVL* pNew=NewAVL(*a);
      pNew->NbrTraverse++;
      if (b=1){
          pNew->NbrDepart++;
      }
      return pNew;
  }
