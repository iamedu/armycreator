#include <insts/strb.h>

@implementation StrbInstruction

-(Word)execute {
	LSAddr *addressing;
	Word Rd;

	addressing = (LSAddr *)[self fetch:_instcode];
        if(addressing == (LSAddr *)Nil)
                return -1;

        [addressing execute];

        if(!cond(_core, _instcode))
                return 0;

        Rd = get_bits(_instcode, 12, 4);

	[_core writeByte:get_bits([_core readReg:Rd], 0, 8) at:[addressing address]];


	return 0;
}

+(UWord)bitmask {
	return 0x0c500000;
}

+(UWord)testmask {
	return 0x04400000;
}

@end

