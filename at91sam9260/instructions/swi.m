#include <insts/swi.h>

@implementation SwiInstruction

-(Word)execute {
	Word cpsr;
	[_core writeSvcReg:14 value:([_core readReg:15] - 4)];
	[_core writeSvcSrc:[_core spsr]];

	[_core setMode:mode_svc];

	cpsr = [_core cpsr];

	cpsr |= 0x00000040;

	//To implement cp15
	//
	[_core writeReg:15 value:0x00000008];


	return 0;
}

+(UWord)bitmask {
	return 0x0f000000;
}

+(UWord)testmask {
	return 0x0f000000;
}

@end

