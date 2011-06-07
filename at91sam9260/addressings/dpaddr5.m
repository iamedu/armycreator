#import <addrs/dpaddr.h>

@implementation DPAddr5

-(Word)execute {
	Word Rm;
	Word shift_imm;

	Rm =  get_bits(_instcode, 0, 4);
	shift_imm = get_bits(_instcode, 7, 5);

	if(shift_imm == 0) {
		_shifter_operand = 0;
		_shifter_carry_out = get_bits([_core readReg:Rm], 31, 1);
	} else {
		_shifter_operand = [_core readReg:Rm] >> shift_imm;
		_shifter_carry_out = get_bits([_core readReg:Rm], shift_imm - 1,
		                              1);
	}

	return 0;
}

+(UWord)bitmask {
	        return 0x0e000070;
}

+(UWord)testmask {
	        return 0x00000020;
}


@end

