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

#include <mkescom/queue.h>
#include <mkescom/mmg.h>

#define NULL 0

MKNode *new_node(void *v) {
	MKNode *node = (MKNode *)mkmalloc( sizeof( MKNode ) );
	node->value = v;
	node->next = NULL;
	return node;
}

void push(MKNode *node) {
	MKNode *lroot = root;
	if(root != NULL){
		while(lroot->next != NULL)
			lroot = lroot->next;
		lroot->next = node;
	}else
		root = node;
	lroot = NULL;
	mkfree(lroot);
}

MKNode *pop() {
	MKNode *lroot = root;
	if( root != NULL ) {
		root = root->next;
		lroot->next = NULL;
	}
	return lroot;
}
