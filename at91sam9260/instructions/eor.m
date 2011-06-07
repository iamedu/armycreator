#include <insts/eor.h>

@implementation EorInstruction

-(Word)execute {
	
	//-------------------------
	DPAddr *addressing;
        Word S;
        Word Rn;
        Word Rd;

        if(!cond(_core, _instcode))
                return;

        S = get_bits(_instcode, 20, 1);
        Rn = get_bits(_instcode, 16, 4);
        Rd = get_bits(_instcode, 12, 4);

        addressing = (DPAddr *)[self fetch:_instcode];

        if(addressing == (DPAddr *)Nil)
                return -1;

        [addressing execute];
	
	[_core writeReg:Rd value:([_core readReg:Rn ^ [addressing shifter_operand]])];
	
	if(S && Rd == 15) {
                if([_core hasSpsr]) {
                        [_core setCpsr:[_core spsr]];
                }
        } else if(S == 1) {
                [_core setStatus:get_bits([_core readReg:Rd], 31, 1)
                         forFlag:status_n];
                [_core setStatus:([_core readReg:Rd] == 0)
                         forFlag:status_z];
                [_core setStatus:[addressing shifter_carry_out]
                         forFlag:status_c];
        }

	return 0;
}

+(UWord)bitmask {
	return 0x0de00000;
}

+(UWord)testmask {
	return 0x00200000;
}

@end

