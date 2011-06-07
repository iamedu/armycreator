#include <insts/sub.h>

@implementation SubInstruction

-(Word)execute {
	Word S;
        Word Rn;
        Word Rd;
        Word borrow;
        Word last_rd;
        Word Cflag = get_bits([_core cpsr],29,1);
	DPAddr *addressing;
	
        if(!cond(_core, _instcode))
                return 0;

	addressing = (DPAddr *)[self fetch:_instcode];
        if(addressing == (DPAddr *)Nil)
                return -1;

        [addressing execute];


        Rn = get_bits(_instcode, 16, 4);
        Rd = get_bits(_instcode, 12, 4);
	S  = get_bits(_instcode, 20, 1);
        last_rd = [_core readReg:Rd];

	[_core writeReg:Rd value:SubWithBorrow([_core readReg:Rn], [addressing shifter_operand], &borrow)];

        if(S && Rd == 15){
		if([_core hasSpsr]) {
                        [_core setCpsr:[_core spsr]];
                }

        }else if(S){
                [_core setStatus:get_bits([_core readReg:Rd], 31, 1)
		       forFlag:status_n];;
                [_core setStatus:([_core readReg:Rd] == 0)
		       forFlag:status_z];
                [_core setStatus:(borrow == 0)
		       forFlag:status_c];
                [_core setStatus:(get_bits([_core readReg:Rn], 31, 1) !=
                                     get_bits([addressing shifter_operand], 31, 1)) &&
                                    (get_bits([addressing shifter_operand], 31, 1) ==
                                     get_bits([_core readReg:Rd], 31, 1))
		       forFlag:status_v];
	}

	return 0;
}

+(UWord)bitmask {
	return 0x0de00000;
}

+(UWord)testmask {
	return 0x00400000;
}

@end

