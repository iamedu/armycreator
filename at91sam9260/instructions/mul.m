#include <insts/mul.h>

@implementation MulInstruction

-(Word)execute {
	Word Rm;
	Word Rd;
	Word Rs;
	Word S;

	if(!cond(_core, _instcode))
		return 0;

	Rm = get_bits(_instcode,0,4);
	Rd = get_bits(_instcode,16,4);
	Rs = get_bits(_instcode,8,4);
	S = get_bits(_instcode,20,0);

	[_core writeReg:Rd value:([_core readReg:Rm] * [_core readReg:Rs])];

	if(S) {
		[_core setStatus:(get_bits([_core readReg:Rd],31,1))
			 forFlag:status_n];
		[_core setStatus:([_core readReg:Rd] == 0)
			 forFlag:status_z];
	}

	return 0;
}

+(UWord)bitmask {
	return 0x0fe0f0f0;
}

+(UWord)testmask {
	return 0x00000090;
}

@end

