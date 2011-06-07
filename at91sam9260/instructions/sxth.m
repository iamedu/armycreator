#include <insts/sxth.h>

@implementation SxthInstruction

-(Word)execute {
	return 0;
}

+(UWord)bitmask {
	return 0x0fff03f0;
}

+(UWord)testmask {
	return 0x06bf0070;
}

@end

