#include <insts/uxtah.h>

@implementation UxtahInstruction

-(Word)execute {
	return 0;
}

+(UWord)bitmask {
	return 0x0ff003f0;
}

+(UWord)testmask {
	return 0x06f00070;
}

@end

