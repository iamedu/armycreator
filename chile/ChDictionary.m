#import <Chiles/ChDictionary.h>
#import <Chiles/Utils.h>
#import <Chiles/Iterator.h>

int hash(int h) {
	unsigned int hh = (unsigned int)h;
	hh ^= (hh >> 20) ^ (hh >> 12);
	return hh ^ (hh >> 7) ^ (hh >> 4);
}

int indexFor(int h, int length) {
	return h & (length - 1);
}

@implementation ChDictionaryElement

-(id)initWithValue:(ChObject *)value key:(ChObject<Hashable> *)key {
	v = value;
	k = key;
	return self;
}
-(ChObject *)value{
	return v;
}
-(ChObject<Hashable> *)key {
	return k;
}
-(void)setValue:(ChObject *)value {
	v = value;
}


@end


@implementation ChDictionary

-(id)init {
	return [self initWithCapacity:DICT_DEFAULT_INITIAL_CAPACITY];
}
-(id)initWithCapacity:(Word)capacity {
	int i;
	table = malloc(sizeof(ChList *) * capacity);
	s = capacity;
	l = 0;

	for(i = 0; i < s; i++) {
		table[i] = [[ChList alloc] init];
	}
	return self;
}

-(void)put:(ChObject *)value at:(ChObject<Hashable> *)key {
	int h;
	int index;
	ChListNode *it;
	ChDictionaryElement *el;

	h = hash([key hash]);
	index = indexFor(h, s);

	it = [table[index] firstNode];

	while(it != (ChListNode *)Nil) {
		el = (ChDictionaryElement *)[it value];
		if(h == hash([[el key] hash]) &&
		  (key == [el key] || [key isEqual:[el key]])) {
		        [[el value] release];
			[el setValue:value];
		        [value retain];
			return;
		}

		it = [it next];
	}

	l++;
	el = [[ChDictionaryElement alloc] initWithValue:value key:key];
	[table[index] insert:el];

}

-(ChObject *)get:(ChObject<Hashable> *)key {
	int h;
	int index;
	ChListNode *it;
	ChDictionaryElement *el;


	h = hash([key hash]);
	index = indexFor(h, s);

	it = [table[index] firstNode];

	while(it != (ChListNode *)Nil) {
		el = (ChDictionaryElement *)[it value];
		if(h == hash([[el key] hash]) &&
		  (key == [el key] || [key isEqual:[el key]])) {
			return [el value];
		}
		it = [it next];
	}

	return (ChObject *)Nil;
}

-(int)length {
	return l;
}

-(int)capacity {
	return s;
}


-(void)merge:(ChDictionary *)other {
	int i;
	ChObject<Iterator> *it;
	ChDictionaryElement *el;
	for(i = 0; i < other->s; i++) {
		it = [other->table[i] iterator];
		while([it hasNext]) {
			el = (ChDictionaryElement *)[it next];
			[self put:[el value] at:[el key]];
		}
	}
}

-(ChList *)keys {
	int i;
	ChList *result;
	ChObject<Iterator> *it;
	ChDictionaryElement *el;

	result = [[ChList alloc] init];

	for(i = 0; i < s; i++) {
		it = [table[i] iterator];
		while([it hasNext]) {
			el = (ChDictionaryElement *)[it next];
			[result insert:[el key]];
		}
	}
	return result;

}

@end

