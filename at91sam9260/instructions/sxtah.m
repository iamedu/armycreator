#include <insts/sxtah.h>

@implementation SxtahInstruction

-(Word)execute {
	return 0;
}

+(UWord)bitmask {
	return 0x0ff003f0;
}

+(UWord)testmask {
	return 0x06b00070;
}

@end

