#include <stdlib.h>
#include <list.h>

ListNode *add_node(ListNode *root, void *value) {
	ListNode *node;
	ListNode *tmp;

	node = (ListNode *)malloc(sizeof(ListNode));
	node->object = value;
	node->next = NULL;

	if(root == NULL) {
		root = node;
	} else {
		tmp = root;
		while(tmp->next != NULL) {
			tmp = tmp->next;
		}
		tmp->next = node;
	}
	return root;
}

ListNode *get_node(ListNode *root, ListNode* expected, 
                   int (*comparator)(void *, void *))	{
	ListNode *tmp = root;
	ListNode *result = NULL;

	while(tmp != NULL) {
		if((*comparator)(expected, tmp)) {
			result = tmp;
			break;
		}
		tmp = tmp->next;
	}
	
	return result;
}

