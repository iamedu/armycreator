#include <insts/ldrbt.h>

@implementation LdrbtInstruction

-(Word)execute {
	LSAddr *addressing;
        Word Rd,Rn;

        addressing = (LSAddr *)[self fetch:_instcode];

        if(addressing == (LSAddr *)Nil)
                return -1;

        Rd = get_bits(_instcode, 12, 4);
	Rn = get_bits(_instcode, 16, 4);

        [addressing execute];

        [_core writeReg:Rd value:[_core readByteAt:[addressing address]]];
	[_core writeReg:Rn value:[addressing address]];
	return 0;

}

+(UWord)bitmask {
	return 0x0d700000;
}

+(UWord)testmask {
	return 0x04700000;
}

@end

