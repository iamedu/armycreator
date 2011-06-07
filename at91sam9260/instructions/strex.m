#include <insts/strex.h>

@implementation StrexInstruction

-(Word)execute {
	LSAddr *addressing;
	addressing = (LSAddr *)[self fetch:_instcode];
        if(addressing == (LSAddr *)Nil)
                return -1;

        [addressing execute];

        if(!cond(_core, _instcode))
                return 0;
	
	return -1;
}

+(UWord)bitmask {
	return 0x0ff00ff0;
}

+(UWord)testmask {
	return 0x01800f90;
}

@end

