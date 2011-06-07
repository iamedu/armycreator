#include <insts/smmul.h>

//ARMv6 Do not implement

@implementation SmmulInstruction

-(Word)execute {
	return 0;
}

+(UWord)bitmask {
	return 0x0ff0f0d0;
}

+(UWord)testmask {
	return 0x0750f010;
}

@end

