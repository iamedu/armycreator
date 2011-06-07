#include <mkescom/queue.h>
#include <mkescom/process.h>
#include <mkescom/sch.h>

#include <stdio.h>
//#define NULL 0

MKNode *root;

int main(){
	int i;
	root = NULL;
	for(i = 0; i < 5; i++)
		push(new_node((void *)init_process()));
	Process *p = NULL;
	do{
		p = get_next(p);
		if(p != NULL){
			printf("Proceso: %d -> size: %d\n", p->pid,p->size);
			for(i = 0; i < 100; i++)
				if(p->size > 0)
					p->size -= 1;
				else
					break;
		}
	}while(p != NULL);
	return 0;
}
