#include <insts/ldrb.h>

@implementation LdrbInstruction

-(Word)execute {
	LSAddr *addressing;
        Word Rd;
	
	addressing = (LSAddr *)[self fetch:_instcode];

        if(addressing == (LSAddr *)Nil)
                return -1;

        Rd = get_bits(_instcode, 12, 4);

        [addressing execute];

	[_core writeReg:Rd value:[_core readByteAt:[addressing address]]];
	return 0;

}
+(UWord)bitmask {
	return 0x0c500000;
}

+(UWord)testmask {
	return 0x04500000;
}

@end

