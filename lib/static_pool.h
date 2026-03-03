#ifndef STATIC_POOL_H
#define STATIC_POOL_H

#include <stddef.h> // Required for NULL

#define MAX_NOF_NODES 10

typedef struct Node_s
{
    int data;
    struct Node_s *link;
} Node_t;

// Function Prototypes (The Menu)
void init(Node_t **pp_free_list);
Node_t* allocate_node(Node_t **pp_free_list);
int deallocate_node(Node_t **pp_free_list, Node_t *node_to_free);
int insert_active_data(Node_t **pp_free_list, Node_t **pp_active_list, int data_to_be_added);
int remove_active_node(Node_t **pp_free_list, Node_t **pp_active_list, int data_to_be_removed);

#endif // STATIC_POOL_H
