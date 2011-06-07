#include <insts/rsc.h>

@implementation RscInstruction

-(Word)execute {
	return 0;
}

+(UWord)bitmask {
	return 0x0de00000;
}

+(UWord)testmask {
	return 0x00e00000;
}

@end

