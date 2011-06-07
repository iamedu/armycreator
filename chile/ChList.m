#import <Chiles/ChList.h>
#import <Chiles/Utils.h>

@implementation ChListNode


-(id)initWithValue:(ChObject *)value {
	//[value retain];
	self = [super init];
	val = value;
	ne = nil;
}

-(ChListNode *)next {
	return ne;
}

-(ChListNode *)addNextValue:(ChObject *)value {
	ChListNode *next;
	next = [[ChListNode alloc] initWithValue:value];
	ne = next;
	return ne;
}

-(ChObject *)value {
	return val;
}

-(void)free {
	if(val != nil) {
		[val release];
	}
	[super free];
}

@end


@implementation ChList

-(id)init {
	self = [super init];
	s = 0;
	root = nil;
}

-(void)insert:(ChObject *)value {
	if(value == nil) {
		return;
	}
	s++;
	if(root == nil) {
		root = [[ChListNode alloc] initWithValue:value];
		last = root;
		return;
	}
	last = [last addNextValue:value];
}

-(ChObject *)objectAt:(int)index {
	int i;
	ChListNode *it;

	if(index >= s) {
		return nil;
	}

	

	for(i = 0, it = root; i < index; i++) {
		it = [it next];
	}

	return [it value];
}

-(int)size {
	return s;
}

-(ChArray *)toArray {
	ChListNode *it;
	ChArray *arr;
	int i;

	it = root;
	i = 0;
	arr = [[ChArray alloc] initWithLength:s];


	while(it != nil) {
		[arr set:[it value] at:i++];
		it = [it next];
	}

	return arr;
}

-(ChListNode*)firstNode {
	return root;
}

-(id<Iterator>)iterator {
	return [[ChListIterator alloc] initWithRoot:root];
}

-(void)free {
	ChListNode *n = root;
	ChListNode *c;
	while(n != nil) {
		c = n;
		n = [n next];
		[c release];
	}
	[super free];
}

-(void)clear {
	ChListNode *n = root;
	ChListNode *c;
	while(n != nil) {
		c = n;
		n = [n next];
		[c release];
	}
	root = nil;
	s = 0;
}

@end


@implementation ChListIterator

-(id)initWithRoot:(ChListNode *)root {
	//[root retain];
	current = root;
	return self;
}

-(ChObject *)next {
	ChObject *value;
	ChListNode *n;

	n     = [current next];
	value = [current value];

	//[current release];
	current = n;

	/*
	if(current != nil)
		[current retain];
	*/
	return value;
}

-(BOOL)hasNext {
	return current != nil;
}


@end


