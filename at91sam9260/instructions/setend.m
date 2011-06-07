#include <insts/setend.h>

//This is just for armv6, meaning we don't need it

@implementation SetendInstruction

-(Word)execute {
	return 0;
}

+(UWord)bitmask {
	return 0xfffffdff;
}

+(UWord)testmask {
	return 0xf1010000;
}

@end

