#include <insts/smlsld.h>

//Do not implement ARMv6 Instruction

@implementation SmlsldInstruction

-(Word)execute {
	return 0;
}

+(UWord)bitmask {
	return 0x0ff000d0;
}

+(UWord)testmask {
	return 0x07400050;
}

@end

