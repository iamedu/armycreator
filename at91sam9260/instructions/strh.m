#include <insts/strh.h>

@implementation StrhInstruction

-(Word)execute {
	MLSAddr *addressing;
	Word cp15_reg1, Rd;

	addressing = (MLSAddr *)[self fetch:_instcode];
        if(addressing == (MLSAddr *)Nil)
                return -1;

        [addressing execute];

        if(!cond(_core, _instcode))
                return 0;

        cp15_reg1 = 0;
        Rd = get_bits(_instcode, 12, 4);
        if( !get_bits(cp15_reg1, 22, 1) )
                if( !get_bits([addressing address], 0 ,1) )
			[_core writeHalfword:get_bits([_core readReg:Rd], 0, 16) at:[addressing address]];
        else
		[_core writeHalfword:get_bits([_core readReg:Rd], 0, 16) at:[addressing address]];

	return 0;
}

+(UWord)bitmask {
	return 0x0e1000f0;
}

+(UWord)testmask {
	return 0x000000b0;
}

@end

