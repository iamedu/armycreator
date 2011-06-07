#include <insts/cmn.h>

@implementation CmnInstruction

-(Word)execute {
	DPAddr *addressing;
        Word S;
        Word Rn;
        Word Rd;
        Word carry;
        Word alu_out;

        if(!cond(_core, _instcode))
                return;

        S = get_bits(_instcode, 20, 1);
        Rn = get_bits(_instcode, 16, 4);
        Rd = get_bits(_instcode, 12, 4);

        addressing = (DPAddr *)[self fetch:_instcode];

        if(addressing == (DPAddr *)Nil)
                return -1;

        [addressing execute];

        alu_out = AddCarryFrom([_core readReg:Rn], [addressing shifter_operand], &carry);

        [_core setStatus:get_bits(alu_out, 31, 1) forFlag:status_n];
        [_core setStatus:(alu_out == 0) forFlag:status_z];
        [_core setStatus:carry forFlag:status_c];

        if(OverflowFrom([_core readReg:Rn], [addressing shifter_operand], alu_out))
		 [_core setStatus:1 forFlag:status_v];
        else
		 [_core setStatus:0 forFlag:status_v];
	
	return 0;
}

+(UWord)bitmask {
	return 0x0df0f000;
}

+(UWord)testmask {
	return 0x01700000;
}

@end

