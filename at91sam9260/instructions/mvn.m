#include <insts/mvn.h>

@implementation MvnInstruction

-(Word)execute {
	DPAddr *addressing;
	Word S;
	Word Rn;
	Word Rd;
	UWord value;

	addressing = (DPAddr *)[self fetch:_instcode];
	if(addressing == (DPAddr *)Nil)
		return -1;

	[addressing execute];

	if(!cond(_core, _instcode))
		return 0;

	Rd = get_bits(_instcode, 12, 4);

	value = [addressing shifter_operand];

	value = ~value;


	[_core writeReg:Rd value:value];

	if(S && Rd == 15) {
		if([_core hasSpsr]) {
			[_core setCpsr:[_core spsr]];
		}
	} else if(S) {
		[_core setStatus:get_bits([_core readReg:Rd],31,1)
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
	return 0x01e00000;
}

@end

