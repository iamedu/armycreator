#include <insts/strd.h>

@implementation StrdInstruction

-(Word)execute {
	MLSAddr *addressing;
	Word Rd;
	Word cp15_reg1;
	
	addressing = (MLSAddr *)[self fetch:_instcode];
        if(addressing == (MLSAddr *)Nil)
                return -1;

        [addressing execute];

        if(!cond(_core, _instcode))
                return 0;

        Rd = get_bits(_instcode, 12, 4);
        cp15_reg1 = 0;
        if( Rd % 2 && Rd != 14 && !get_bits([addressing address], 0, 2) && (get_bits(cp15_reg1, 22, 1) || !get_bits([addressing address], 2, 1)) ){
		[_core writeWord:[_core readReg:Rd] at:[addressing address]];
		[_core writeWord:[_core readReg:Rd+1] at:[addressing address] + 4];
        }

	return 0;
}

+(UWord)bitmask {
	return 0x0e1000f0;
}

+(UWord)testmask {
	return 0x000000f0;
}

@end

