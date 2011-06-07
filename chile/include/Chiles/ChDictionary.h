#ifndef _CHILES_CHDICTIONARY_H
#define _CHILES_CHDICTIONARY_H

#import <Chiles/ChObject.h>
#import <Chiles/ChList.h>
#import <Chiles/Hashable.h>

#define DICT_DEFAULT_INITIAL_CAPACITY 16

@interface ChDictionaryElement : ChObject {
	ChObject<Hashable> *k;
	ChObject *v;
}

-(id)initWithValue:(ChObject *)value key:(ChObject<Hashable> *)key;
-(ChObject *)value;
-(ChObject<Hashable> *)key;
-(void)setValue:(ChObject *)value;

@end


@interface ChDictionary : ChObject {
	ChList **table;
	int s;
	int l;
}

-(id)initWithCapacity:(Word)capacity;
-(void)put:(ChObject *)value at:(ChObject<Hashable> *)key;
-(ChObject *)get:(ChObject<Hashable> *)key;
-(int)length;
-(int)capacity;
-(void)merge:(ChDictionary *)other;
-(ChList *)keys;

@end

#endif

