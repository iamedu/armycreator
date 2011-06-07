#include <insts/ldrex.h>

//ARMv6 DO NOT IMPLEMENT

@implementation LdrexInstruction

-(Word)execute {
	return 0;
}

+(UWord)bitmask {
	return 0x0ff00fff;
}

+(UWord)testmask {
	return 0x01900f9f;
}

@end

