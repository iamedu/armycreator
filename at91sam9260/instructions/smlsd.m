#include <insts/smlsd.h>

//ARMv6 DO NOT IMPLEMENT

@implementation SmlsdInstruction

-(Word)execute {
	return 0;
}

+(UWord)bitmask {
	return 0x0ff000d0;
}

+(UWord)testmask {
	return 0x07000050;
}

@end

