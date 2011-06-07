#include <insts/strt.h>

@implementation StrtInstruction

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
	[_core writeWord:[_core readReg:Rd] at:[addressing address]];

	return 0;
}

+(UWord)bitmask {
	return 0x0d700000;
}

+(UWord)testmask {
	return 0x04200000;
}

@end

