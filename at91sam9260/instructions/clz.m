#include <insts/clz.h>

@implementation ClzInstruction

-(Word)execute {
	Word Rm, Rd;
        Rm = get_bits(_instcode, 0, 4);
        Rd = get_bits(_instcode, 12, 4);
        if( ![_core readReg:Rm] )
               [_core writeReg:Rd value:32];
        else
                Rd = 31 - msb_position([_core readReg:Rm]);

	return 0;
}

+(UWord)bitmask {
	return 0x0fff0ff0;
}

+(UWord)testmask {
	return 0x016f0f10;
}

@end

