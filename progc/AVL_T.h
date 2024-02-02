#ifndef AVLT_FONCTIONS
#define AVLT_FONCTIONS

typedef struct AVL{
    struct AVL* FD;
    struct AVL* FG;
    char* ville;
    int NbrTraverse;
    int NbrDepart;
    int Hauteur;
} AVL;

AVL* NewAVL1(char* ville, short  depart){
    

int Hauteur(AVL* element){
  

int fequilibre(AVL* element){
   
AVL* rotationADroite(AVL*element){
    AVL* pivot=element->FG;
    element->FG=element->FG->FD;
    pivot->FD=element;
    element->Hauteur=Hauteur(element);
    pivot->Hauteur=Hauteur(element);
    return pivot;
}

AVL* rotationAGauche(AVL*element){
    

AVL* insertElementAVL1(AVL* element, char* ville, short depart){
    

AVL* insertElementAVL2(AVL* element, AVL* pNew){
   

void Affichage(AVL*element){
#endif
