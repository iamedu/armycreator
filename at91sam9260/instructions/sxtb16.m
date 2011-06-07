#include <insts/sxtb16.h>

@implementation Sxtb16Instruction

-(Word)execute {
	return 0;
}

+(UWord)bitmask {
	return 0x0fff03f0;
}

+(UWord)testmask {
	return 0x068f0070;
}

@end

