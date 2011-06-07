#include <insts/teq.h>

@implementation TeqInstruction

-(Word)execute {
	DPAddr *addressing;
        Word alu_out;
        Word Rn;
		
	addressing = (DPAddr *)[self fetch:_instcode];
        if(addressing == (DPAddr *)Nil)
                return -1;

        [addressing execute];

        Rn = get_bits(_instcode,16,4);

	if(!cond(_core, _instcode))
                return 0;
        alu_out = [_core readReg:Rn] ^ [addressing shifter_operand];
        [_core setStatus:get_bits(alu_out,31,1) forFlag:status_n];
        [_core setStatus:alu_out == 0 forFlag:status_z];
        [_core setStatus:[addressing shifter_carry_out] forFlag:status_c];
	
	return 0;
}

+(UWord)bitmask {
	return 0x0df0f000;
}

+(UWord)testmask {
	return 0x01300000;
}

@end

