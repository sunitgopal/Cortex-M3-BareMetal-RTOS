#include "static_pool.h"


Node_t pool[MAX_NOF_NODES];


/*  Step 1: Init() fcn that :
        1. links all nodes in the (global)pool to form a chain
        2. links all nodes in the pool to the free-list
*/
void init(Node_t **pp_free_list)
{
    /* In a loop, link each node with the next one */
    for(int i=0; i<(MAX_NOF_NODES-1); i++)
    {
        pool[i].link = &pool[i+1];
    }

    /* NULL the last node's link */
    pool[MAX_NOF_NODES-1].link = NULL;

    /*  */
    *pp_free_list = &pool[0];

    return;
}


/* Step 2: Allocate_node() fcn that:
            1. returns the next free node from the free-list
            2. updates the free_list_ptr
            3. avoid using global
*/

Node_t* allocate_node(Node_t **pp_free_list)
{
    /* First, check if the pp is valid */
    if(pp_free_list == NULL)
    {
        /* Box (containing free_list_ptr) is empty */
        return NULL;
    }

    /* then, check if the free-list exists (i.e., there's at least one free Node) */
    if(*pp_free_list == NULL)
    {
        /* Empty free-list or End of free-list reached */
        return NULL;
    }

    Node_t *allocated_node_ptr = *pp_free_list;
    *pp_free_list = (*pp_free_list)->link;
    allocated_node_ptr->link = NULL;
    return allocated_node_ptr;
}

/* Step 3: Deallocate_node() fcn that:
            1. updates the free_list by:
                adding the node_to_free to the free-list by
                    making the free_list_ptr point to the node_to_free
*/

int deallocate_node(Node_t **pp_free_list, Node_t *node_to_free)
{
    /* First, check if the pp is valid */
    if(pp_free_list == NULL)
    {
        /* Box (containing free_list_ptr) is empty */
        return -1;
    }

    /* then, check if node_to_free is valid */
    if(node_to_free == NULL)
    {
        /* Invalid ptr to node_to_free */
        return -1;
    }

    node_to_free->link = *pp_free_list;
    *pp_free_list = node_to_free;

    return 0;   // success
}

/* Step 4: Insert active node :
    1. Check pp_free and pp_active for NULL (Safety Tier 1)
    2. Try to get a node from the free list
    3. If node is NULL, return an error code (System Overload)
    4. Fill node with 'value'
    5. Insert node at the front of the active list
    6. Return 0 for success
*/
int insert_active_data(Node_t **pp_free_list, Node_t **pp_active_list, int data_to_be_added)
{
    if((pp_free_list == NULL) || (pp_active_list == NULL))
    {
        // If Either of the "boxes" are empty
        return -1;
    }

    Node_t *p_new_node =  allocate_node(pp_free_list);

    if(p_new_node == NULL)
    {
//        printf("allocate_node() Failed!\n");
        return -1;
    }

    /* Attach new_node to the front of active_list */
    p_new_node->link = *pp_active_list;
    p_new_node->data = data_to_be_added;

    /* Update p_active_list */
    *pp_active_list = p_new_node;

    return 0;   // success
}

/* Step 5: Remove active node:
            1. Search the active-list for the data to be removed
            2. Keep track of prev Node
            3. Sew after snip
            4. Deallocate node
*/
int remove_active_node(Node_t **pp_free_list, Node_t **pp_active_list, int data_to_be_removed)
{
    if((NULL == pp_free_list) || (NULL == pp_active_list))
    {
        return -1;
    }

    Node_t *prev_Node = NULL;
    Node_t *trav_Node = *pp_active_list;

    for( ; trav_Node != NULL; trav_Node = trav_Node->link)
    {
        if(trav_Node->data != data_to_be_removed)
        {
            prev_Node = trav_Node;
        }
        else
        {
                /* Data found */

            if (NULL == prev_Node)
            {
                /* EDGE CASE: Head of Active-list is to be removed */
                *pp_active_list = trav_Node->link;
            }
            else
            {
                prev_Node->link = trav_Node->link;
            }

            break;
        }
    }

    if(NULL == trav_Node)
    {
//        printf("Data-to-be-removed not found!\n");
        return -1;
    }
    else
    {
        deallocate_node(pp_free_list, trav_Node);
    }

    return 0;
}
