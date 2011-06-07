#include <insts/smla.h>

@implementation SmlaInstruction

-(Word)execute {
	Word Rm;
        Word Rd;
        Word Rs;
        Word Rn;
	Word x;
	Word y;
	Word last_rd;
	Word operand1,
             operand2;

	Rm = get_bits(_instcode,0,4);
        Rd = get_bits(_instcode,16,4);
        Rs = get_bits(_instcode,8,4);
        Rn = get_bits(_instcode,12,4);
	x = get_bits(_instcode,5,1);
	y = get_bits(_instcode,6,1);

        if(!cond(_core, _instcode))
		return 0;
        if(x == 0)
               operand1 = SignExtend(get_bits([_core readReg:Rm],0,16),16); 
	else
               operand1 = SignExtend(get_bits([_core readReg:Rm],16,16),16);

	if(y == 0)
               operand2 = SignExtend(get_bits([_core readReg:Rs],0,16),16); 
	else 
               operand2 = SignExtend(get_bits([_core readReg:Rs],16,16),16); 

	last_rd = [_core readReg:Rd];

	[_core writeReg:Rd value:(operand1 * operand2) + [_core readReg:Rn]];

	if(OverflowFrom(operand1*operand2, last_rd, [_core readReg:Rd])) 
		[_core setStatus:1 forFlag:status_q];


	return 0;
}

+(UWord)bitmask {
	return 0x0ff00090;
}

+(UWord)testmask {
	return 0x01000080;
}

@end

