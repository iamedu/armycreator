#include <insts/smlalxy.h>

@implementation SmlalxyInstruction

-(Word)execute {
	UWord RdLo = get_bits(_instcode,12,4);
        UWord RdHi = get_bits(_instcode,16,4);
        Word Rs = get_bits(_instcode,8,4);
        Word Rm = get_bits(_instcode,0,4);
        Word x = get_bits(_instcode,5,1);
        Word y = get_bits(_instcode,6,1);
        Word last_rd;
	Word result;
	Word carry;
        Word operand1,operand2;
        if(!cond(_core,_instcode))
		return 0;
        if(x == 0)
                operand1 = SignExtend(get_bits([_core readReg:Rm],0,16),16);
        else
                operand1 = SignExtend(get_bits([_core readReg:Rm],16,16),16);

        if(y == 0)
                operand2 = SignExtend(get_bits([_core readReg:Rs],0,16),16);
        else
                operand2 = SignExtend(get_bits([_core readReg:Rs],16,16),16);
		
	if((operand1 * operand2) < 0){
		result = 0xFFFFFFFF;
	}
	else{
		result = 0;
	}

	[_core writeReg:RdLo value:[_core readReg:RdLo] +
	                           AddCarryFrom(RdLo,
				               (operand1 * operand2),
				               &carry)];	
	[_core writeReg:RdHi value:[_core readReg:RdHi] +
	                           [_core readReg:RdLo] +
				   result +
				   carry];

	return 0;
}

+(UWord)bitmask {
	return 0x0ff00090;
}

+(UWord)testmask {
	return 0x01400080;
}

@end

