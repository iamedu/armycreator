typedef struct {
	void *object;
	void *next;
} ListNode;

ListNode *add_node(ListNode *root, void *value);
ListNode *get_node(ListNode *root, ListNode* expected,
                   int (*comparator)(void *, void *));

