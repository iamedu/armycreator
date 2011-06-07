#include <insts/mrc.h>
#import <armyc/ARMCoproc.h>

@implementation MrcInstruction

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

	[coproc executeMrc:_instcode withAddr:addressing];

	
	if(Rd == 15) {
		[_core setStatus:get_bits(data,31,1) forFlag:status_n];
		[_core setStatus:get_bits(data,30,1) forFlag:status_z];
		[_core setStatus:get_bits(data,29,1) forFlag:status_c];
		[_core setStatus:get_bits(data,28,1) forFlag:status_v];
	} else {
		[_core writeReg:Rd value:data];
	}

	return 0;
}

+(UWord)bitmask {
	return 0x0f100010;
}

+(UWord)testmask {
	return 0x0e100010;
}

@end

