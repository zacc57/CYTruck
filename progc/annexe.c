#include <stdio.h>
#include <stdlib.h>
#include <string.h>



typedef struct {
    int numero_etape;
    char ville_depart[50];
    char ville_arrivee[50];
    int distance;
} Etape;


typedef struct Node {
    Etape etape;
    struct Node* left;
    struct Node* right;
    int height;
} Node;



Node* createNode(Etape etape) {
    Node* newNode = (Node*)malloc(sizeof(Node));
    newNode->etape = etape;
    newNode->left = NULL;
    newNode->right = NULL;
    newNode->height = 1;  // Nouveau nœud a une hauteur de 1
    return newNode;
}


int getBalance(Node* node) {
    if (node == NULL)
        return 0;
    return height(node->left) - height(node->right);
}



void freeTree(Node* root) {
    if (root != NULL) {
        freeTree(root->left);
        freeTree(root->right);
        free(root);
    }
}