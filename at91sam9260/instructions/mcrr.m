#include <insts/mcrr.h>
#import <armyc/ARMCoproc.h>

@implementation McrrInstruction

-(Word)execute {
	Word Rd;
	Word cp_num;
	Word Rn;
	LSCAddr *addressing;
	ARMCoproc *coproc;

	cp_num = get_bits(_instcode, 8, 4);
	addressing = (LSCAddr *)[self fetch:_instcode];
	Rd = get_bits(_instcode, 12, 4);
	Rn = get_bits(_instcode, 16, 4);

	if(addressing == (LSCAddr *)Nil) {
		return -1;
	}

	[addressing execute];

	if(cond(_core, _instcode)) {
		return 0;
	}

	coproc = (ARMCoproc *)[_core getCoprocAt:cp_num];

	[coproc executeMcrr:_instcode withAddr:addressing];

	return 0;
}

+(UWord)bitmask {
	return 0x0ff00000;
}

+(UWord)testmask {
	return 0x0c400000;
}

@end

