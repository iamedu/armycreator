#include <insts/uxtab16.h>

@implementation Uxtab16Instruction

-(Word)execute {
	return 0;
}

+(UWord)bitmask {
	return 0x0ff003f0;
}

+(UWord)testmask {
	return 0x06c00070;
}

@end

