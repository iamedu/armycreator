#include <insts/smlad.h>

//This one is for ARMv6 and above

@implementation SmladInstruction

-(Word)execute {
	return 0;
}

+(UWord)bitmask {
	return 0x0ff000d0;
}

+(UWord)testmask {
	return 0x07000010;
}

@end

