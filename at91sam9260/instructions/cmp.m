#include <insts/cmp.h>

@implementation CmpInstruction

-(Word)execute {
	DPAddr *addressing;
        Word S;
        Word Rn;
        Word borrow;
        Word alu_out;

        if(!cond(_core, _instcode))
                return;

        S = get_bits(_instcode, 20, 1);
        Rn = get_bits(_instcode, 16, 4);

        addressing = (DPAddr *)[self fetch:_instcode];

        if(addressing == (DPAddr *)Nil)
                return -1;

        [addressing execute];

        alu_out = SubWithBorrow([_core readReg:Rn], [addressing shifter_operand], &borrow);
	
	[_core debug:@"valor del borrow %d\n",borrow];

        [_core setStatus:get_bits(alu_out, 31, 1) forFlag:status_n];
        [_core setStatus:(alu_out == 0) forFlag:status_z];
        [_core setStatus:!borrow forFlag:status_c];
        [_core setStatus:(get_bits([_core readReg:Rn], 31, 1) != get_bits([addressing shifter_operand], 31, 1)) && (get_bits([addressing shifter_operand], 31, 1) == get_bits(alu_out, 31, 1)) 
				forFlag:status_v];

	return 0;
}

+(UWord)bitmask {
	return 0x0df0f000;
}

+(UWord)testmask {
	return 0x01500000;
}

@end

