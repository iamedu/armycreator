#include <insts/smuad.h>

//ARMv6 DO NOT IMPLEMENT

@implementation SmuadInstruction

-(Word)execute {
	return 0;
}

+(UWord)bitmask {
	return 0x0ff0f0d0;
}

+(UWord)testmask {
	return 0x0700f010;
}

@end

