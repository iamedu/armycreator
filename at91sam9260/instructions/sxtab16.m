#include <insts/sxtab16.h>

@implementation Sxtab16Instruction

-(Word)execute {
	return 0;
}

+(UWord)bitmask {
	return 0x0ff003f0;
}

+(UWord)testmask {
	return 0x06800070;
}

@end

