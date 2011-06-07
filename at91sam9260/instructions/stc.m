#include <insts/stc.h>

@implementation StcInstruction

-(Word)execute {
	LSCAddr *addressing;
	addressing = (LSCAddr *)[self fetch:_instcode];
        if(addressing == (LSCAddr *)Nil)
                return -1;

        [addressing execute];

        if(!cond(_core, _instcode))
                return 0;
	return 0;
}

+(UWord)bitmask {
	return 0x0e100000;
}

+(UWord)testmask {
	return 0x0c000000;
}

@end

