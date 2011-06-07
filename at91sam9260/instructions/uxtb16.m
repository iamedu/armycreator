#include <insts/uxtb16.h>

@implementation Uxtb16Instruction

-(Word)execute {
	return 0;
}

+(UWord)bitmask {
	return 0x0fff03f0;
}

+(UWord)testmask {
	return 0x06cf0070;
}

@end

