#include <insts/umaal.h>

@implementation UmaalInstruction

-(Word)execute {
	return 0;
}

+(UWord)bitmask {
	return 0x0ff000f0;
}

+(UWord)testmask {
	return 0x00400090;
}

@end

