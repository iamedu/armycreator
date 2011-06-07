#include <insts/cdp.h>

@implementation CdpInstruction

-(Word)execute {
	LSCAddr *addressing;
	if(!cond(_core, _instcode))
                return;

        addressing = (LSCAddr *)[self fetch:_instcode];

        if(addressing == (LSCAddr *)Nil)
                return -1;
        [addressing execute];

	//Coprocessor[cp_num]-dependent operation

	return 0;
}

+(UWord)bitmask {
	return 0x0f000010;
}

+(UWord)testmask {
	return 0x0e000000;
}

@end

