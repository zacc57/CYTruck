#ifndef AVLS_FONCTIONS
#define AVLS_FONCTIONS

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

AVL* NewAVL1(int ID, int distance)
   

AVL* NewAVL2(AVL*element)
    
int Hauteur(AVL* element)
  
int fequilibre(AVL* element)
    

AVL* rotationADroite(AVL*element)
    

AVL* rotationAGauche(AVL*element)
    

AVL* insertElementAVL1(AVL* element, int stepID, int distance, )
    
void FreeAVL(AVL* element) 

#endif
