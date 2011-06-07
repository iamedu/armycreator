#ifndef _CHOBJECT_H
#define _CHOBJECT_H

#import <stdlib.h>
#import <objc/objc.h>
#import <objc/objc-api.h>
#import <Chiles/ChTypes.h>

@class ChString;

typedef struct {
	Word retainCount;
} ChObjectExtra;

@interface ChObject {
	Class isa;
}

+ (id)alloc;
- (id)init;

- (id)self;
- (Class)class;
- (Class)superclass;

+ (Class)class;
+ (Class)superclass;

- (BOOL) isEqual: (id)other;
- (BOOL) isKindOfClass: (Class)class;
- (BOOL) isMemberOfClass: (Class)class;
- (id)performSelector:(SEL)sel;

- (IMP)methodFor:(SEL)sel;

- (void)free;
- (void)selfFree;
- (id)retain;
- (void)release;
- (UWord)retainCount;

-(ChString *)description;

@end


#endif
