/*
 * This file is part of mkescom.
 * 
 * mkescom is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.

 * mkescom is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.

 * You should have received a copy of the GNU General Public License
 * along with mkescom.  If not, see <http://www.gnu.org/licenses/>.
 */

#include <mkescom/sch.h>
#include <mkescom/process.h>
#include <mkescom/queue.h>

#define NULL 0

Process *get_next(Process *p) {
	MKNode* node;
	if(p != NULL)
		if(p->size != 0) {
			push(new_node((void *)p));
		}
	node = pop();
	if(node != NULL)
		return (Process *) node->value;
	else
		return NULL;
}

Process *get_process(int pid) {
	MKNode *lroot = root;
        if( root != NULL )
                while( ( (Process *) lroot->value )->pid != pid )
                        lroot = lroot->next;
        return (Process *) lroot->value;
}

int current_process() {
	MKNode *lroot = root;
	int pid;
	while( ( (Process *) lroot->value)->executing != 1)
		lroot = lroot->next;
	pid = ((Process *) lroot->value)->pid;
	lroot = NULL;
	mkfree(lroot);
	return pid;
}

void kill(int pid) {
	MKNode *lroot = root;
        if( root != NULL ) {
                while( ( (Process *) lroot->next->value )->pid != pid )
                        lroot = lroot->next;
                lroot->next = lroot->next->next;
        }
        lroot = NULL;
        mkfree(lroot);
}
