#include <insts/uxtb.h>

@implementation UxtbInstruction

-(Word)execute {
	return 0;
}

+(UWord)bitmask {
	return 0x0fff03f0;
}

+(UWord)testmask {
	return 0x06ef0070;
}

@end

