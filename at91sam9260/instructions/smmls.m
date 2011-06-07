#include <insts/smmls.h>

//ARMv6 Do not implement

@implementation SmmlsInstruction

-(Word)execute {
	return 0;
}

+(UWord)bitmask {
	return 0x0ff000d0;
}

+(UWord)testmask {
	return 0x075000d0;
}

@end

