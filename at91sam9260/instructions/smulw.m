#include <insts/smulw.h>

@implementation SmulwInstruction

-(Word)execute {

	Word Rm = get_bits(_instcode,0,4);
        Word Rd = get_bits(_instcode,16,4);
        Word Rs = get_bits(_instcode,8,4);
        Word Rn = get_bits(_instcode,12,4);
        Word y = get_bits(_instcode,6,1);
        Word operand2;

        if(!cond(_core,_instcode))
		return 0;

        if(y == 0)
                operand2 = SignExtend(get_bits([_core readReg:Rs],0,16),16);
        else
                operand2 = SignExtend(get_bits([_core readReg:Rs],16,16),16);
        [_core writeReg:Rd value:([_core readReg:Rm] * operand2) +
	                          [_core readReg:Rn]];//TO DO

	return 0;
}

+(UWord)bitmask {
	return 0x0ff0f0b0;
}

+(UWord)testmask {
	return 0x012000a0;
}

@end

