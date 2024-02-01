#include <stdio.h>
#include <stdlib.h>
#include <string.h>

typedef struct _node {
    int depart;
    int total_trajet;
    struct _node* gauche;
    struct _node* droite;
    int hauteur; 
    char ville[50];
}Node;


typedef struct _avl {
     Node* node;   
}AVL;


AVL AVL1T;
AVL1T.node = NULL;


AVL AVL2T;
AVL2T.node = NULL;


AVL* creationNode(char* ville)
{
AVL node = malloc(sizeof(AVL))
strcpy(node->ville, ville);
node->depart = 0;
node->total_trajet = 0;
node->gauche = NULL;
node->droite = NULL;
node->hauteur = 1;
return node;
}


int hauteur(AVL node)
{
if (node == NULL)
{
 return 0;
 }
 return node->hauteur;
 }
 
 int max(int x, int y)
 {
 return (a > b) ? a : b;
 }
