#include <insts/mrs.h>

@implementation MrsInstruction

-(Word)execute {
	Word R;
	Word Rd;

	R = get_bits(_instcode, 22, 1);
	Rd = get_bits(_instcode, 12, 4);

	if(!cond(_core, _instcode)) {
		return 0;
	}

	if(R) {
		[_core writeReg:Rd value:[_core spsr]];
	} else {
		[_core writeReg:Rd value:[_core cpsr]];
	}

	return 0;
}

+(UWord)bitmask {
	return 0x0fbf0fff;
}

+(UWord)testmask {
	return 0x010f0000;
}

@end

