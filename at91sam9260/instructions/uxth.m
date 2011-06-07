#include <insts/uxth.h>

@implementation UxthInstruction

-(Word)execute {
	return 0;
}

+(UWord)bitmask {
	return 0x0fff03f0;
}

+(UWord)testmask {
	return 0x06ff0070;
}

@end

