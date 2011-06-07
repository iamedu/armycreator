#include <insts/smlaw.h>

@implementation SmlawInstruction

-(Word)execute {
	Word Rm = get_bits(_instcode,0,4);
        Word Rd = get_bits(_instcode,16,4);
        Word Rs = get_bits(_instcode,8,4);
        Word Rn = get_bits(_instcode,12,4);
        Word y = get_bits(_instcode,6,1);
        Word last_rd;
        Word operand2;

        if(!cond(_core,_instcode))
		return 0;
        if(y == 0)
                operand2 = SignExtend(get_bits([_core readReg:Rs],0,16),16);
        else
                operand2 = SignExtend(get_bits([_core readReg:Rs],16,16),16);

        last_rd = [_core readReg:Rd];

        [_core writeReg:Rd value:([_core readReg:Rm] * operand2) +
	                         [_core readReg:Rn]];//TO DO

        if(OverflowFrom(last_rd, last_rd, [_core readReg:Rn]))
                [_core setStatus:1 forFlag:status_q];

	return 0;
}

+(UWord)bitmask {
	return 0x0ff000b0;
}

+(UWord)testmask {
	return 0x01200080;
}

@end

