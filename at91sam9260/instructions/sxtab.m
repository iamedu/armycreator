#include <insts/sxtab.h>

@implementation SxtabInstruction

-(Word)execute {
	return 0;
}

+(UWord)bitmask {
	return 0x0ff003f0;
}

+(UWord)testmask {
	return 0x06a00070;
}

@end

