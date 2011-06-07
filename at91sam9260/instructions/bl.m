#include <insts/bl.h>
#include <armyc/utils.h>

@implementation BlInstruction

-(Word)execute {
	Word L;
	Word signed_immed_24;
	UWord value;

	L = get_bits(_instcode, 24, 1);
	
	if(!cond(_core, _instcode)) {
		return 0;
	}

	signed_immed_24 = get_bits(_instcode, 0, 24);

	if(L) {
		[_core writeReg:14 value:([_core readReg:15] - 4)];
	}

	value = (SignExtend30(signed_immed_24, 24) << 2);
	value += [_core readReg:15];

	[_core writeReg:15 value:value];

	return 0;
}

+(UWord)bitmask {
	return 0x0e000000;
}

+(UWord)testmask {
	return 0x0a000000;
}

@end

