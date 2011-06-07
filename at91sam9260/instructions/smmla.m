#include <insts/smmla.h>

//ARMv6 Do not implement

@implementation SmmlaInstruction

-(Word)execute {
	return 0;
}

+(UWord)bitmask {
	return 0x0ff000d0;
}

+(UWord)testmask {
	return 0x07500010;
}

@end

