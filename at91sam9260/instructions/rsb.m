#include <insts/rsb.h>

@implementation RsbInstruction

-(Word)execute {
	DPAddr *addressing;
	Word S;
	Word Rn;
	Word Rd;
	Word borrow;
	Word lastRd;
	Word carry;

	addressing = (DPAddr *)[self fetch:_instcode];
	if(addressing == (DPAddr *)Nil)
		return -1;

	[addressing execute];

	if(!cond(_core, _instcode))
		return 0;

	Rd = get_bits(_instcode, 12, 4);
	Rn = get_bits(_instcode, 16, 4);
	S = get_bits(_instcode, 20, 1);

	lastRd = [_core readReg:Rd];

	[_core writeReg:Rd 
	          value:SubWithBorrow([addressing shifter_operand], 
				      [_core readReg:Rn],
				      &borrow)];

	if(S && Rd == 15) {
		if([_core hasSpsr]) {
			[_core setCpsr:[_core spsr]];
		}
	} else if(S) {
		[_core setStatus:get_bits([_core readReg:Rd],31,1)
		         forFlag:status_n];
		[_core setStatus:([_core readReg:Rd] == 0)
		         forFlag:status_z];
		[_core setStatus:(borrow == 0)
		         forFlag:status_c];
		[_core setStatus:(OverflowFrom(lastRd, [addressing shifter_operand], [_core readReg:Rd]))
		         forFlag:status_v];
	}
	return 0;
}

+(UWord)bitmask {
	return 0x0de00000;
}

+(UWord)testmask {
	return 0x00600000;
}

@end

