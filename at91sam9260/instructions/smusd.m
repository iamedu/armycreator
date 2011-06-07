#include <insts/smusd.h>

//ARMV6 Do not implement

@implementation SmusdInstruction

-(Word)execute {
	return 0;
}

+(UWord)bitmask {
	return 0x0ff0f0d0;
}

+(UWord)testmask {
	return 0x0700f050;
}

@end

