#include<iostream>
using namespace std;

struct Node{
    int data;
    struct Node* left;
    struct Node* right;
    Node(int val)
    {
        data = val;
        left = NULL;
        right = NULL;
    }
};

//Properties:
//- The maximum number of nodes at level ‘l’ of a binary tree is 2^l
//The Maximum number of nodes in a binary tree of height ‘h’ is 2^h – 1
int main(){
    struct Node* root = new  Node(1);//Root

    root->left = new Node(2);
    root->right = new Node(3);

    root->left->left = new Node(4);
    root->left->right = new Node(5);
    root->right->left = new Node(6);
    root->right->right = new Node(7); 
    cout<<"Hello";
    return 0;
}