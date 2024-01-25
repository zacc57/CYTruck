#include <stdio.h>
#include <stdlib.h>
#include <string.h>


int


moyenne_AVL(AVL* node){
if (node == NULL)
  return 0.0;

nombres_nodes = 1 + 
}





min_AVL(){

if (node == NULL)
{
return 0;
}

while (node->gauche != NULL)
{
node = node->gauche;
}
return node->gauche;

}


max_AVL(){
while (node->droite != NULL)
{
node = node->droite;
}
return node;
}
