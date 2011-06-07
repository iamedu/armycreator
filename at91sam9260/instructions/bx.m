#include <insts/bx.h>

@implementation BxInstruction

-(Word)execute {
	Word Rm;

        if(!cond(_core, _instcode)) {
                return 0;
        }

        Rm = get_bits(_instcode, 0, 4);

        [_core setStatus:get_bits([_core readReg:Rm], 0, 1) forFlag:status_t];
        [_core writeReg:15 value:([_core readReg:Rm] & 0xFFFFFFFE)];

        return 0;
}

+(UWord)bitmask {
	return 0x0ffffff0;
}

+(UWord)testmask {
	return 0x012fff10;
}

@end

