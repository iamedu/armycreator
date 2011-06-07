#include <insts/smlald.h>

//Smlald is for ARMv6 and above

@implementation SmlaldInstruction

-(Word)execute {
	return 0;
}

+(UWord)bitmask {
	return 0x0ff000d0;
}

+(UWord)testmask {
	return 0x07400010;
}

@end

