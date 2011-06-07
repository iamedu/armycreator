#include <insts/ldrsb.h>

@implementation LdrsbInstruction

-(Word)execute {
	
	MLSAddr *addressing;
        Word Rd;
        Word data;

        if(!cond(_core, _instcode))
                return;

        Rd = get_bits(_instcode, 12, 4);

        addressing = (MLSAddr *)[self fetch:_instcode];

        if(addressing == (MLSAddr *)Nil)
                return -1;
        [addressing execute];
	
	data = [_core readByteAt:[addressing address]];
	[_core writeReg:Rd value:SignExtend(data,8)];

	return 0;
}

+(UWord)bitmask {
	return 0x0e1000f0;
}

+(UWord)testmask {
	return 0x001000d0;
}

@end

