#include <insts/sxtb.h>

@implementation SxtbInstruction

-(Word)execute {
	return 0;
}

+(UWord)bitmask {
	return 0x0fff03f0;
}

+(UWord)testmask {
	return 0x06af0070;
}

@end

