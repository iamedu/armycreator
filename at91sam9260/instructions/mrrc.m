#include <insts/mrrc.h>
#import <armyc/ARMCoproc.h>

@implementation MrrcInstruction

-(Word)execute {
	LSCAddr *addressing;
	Word Rd;
	Word cp_num;
	Word data;
	ARMCoproc *coproc;

	if(!cond(_core, _instcode))
		return 0;

	addressing = (LSCAddr *)[self fetch:_instcode];
	cp_num = get_bits(_instcode, 8, 4);
	Rd = get_bits(_instcode, 12, 4);


	if(addressing == (LSCAddr *)Nil)
		return -1;

	coproc = (ARMCoproc *)[_core getCoprocAt:cp_num];

	[coproc executeMrrc:_instcode withAddr:addressing];

	return 0;
}

+(UWord)bitmask {
	return 0x0ff00000;
}

+(UWord)testmask {
	return 0x0e000010;
}

@end

