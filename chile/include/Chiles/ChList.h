#ifndef _CHILES_CHLIST_H
#define _CHILES_CHLIST_H

#import <Chiles/ChObject.h>
#import <Chiles/ChArray.h>
#import <Chiles/Iterator.h>


@interface ChListNode : ChObject {
	ChObject *val;
	ChListNode *ne;
}

-(id)initWithValue:(ChObject *)value;
-(ChListNode *)next;
-(ChListNode *)addNextValue:(ChObject *)value;
-(ChObject *)value;

@end

@interface ChListIterator : ChObject <Iterator> {
	ChListNode *current;
}

-(id)initWithRoot:(ChListNode *)root;

@end

@interface ChList : ChObject {
	ChListNode *root;
	ChListNode *last;
	int s;
}

-(void)insert:(ChObject *)value;
-(void)clear;
-(ChObject *)objectAt:(int)index;
-(int)size;
-(ChArray *)toArray;
-(id<Iterator>)iterator;
-(ChListNode *)firstNode;

@end

#endif

