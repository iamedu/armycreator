#include <insts/uxtab.h>

@implementation UxtabInstruction

-(Word)execute {
	return 0;
}

+(UWord)bitmask {
	return 0x0ff003f0;
}

+(UWord)testmask {
	return 0x06e00070;
}

@end

