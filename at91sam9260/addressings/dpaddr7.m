#import <addrs/dpaddr.h>

@implementation DPAddr7

-(Word)execute {
	Word shift_imm;
	Word Rm;

	shift_imm = get_bits(_instcode, 7, 5);
	Rm = get_bits(_instcode, 0, 4);

	if(shift_imm == 0) {
		if(get_bits([_core readReg:Rm], 31, 1) == 0) {
			_shifter_operand = 0;
			_shifter_carry_out = get_bits([_core readReg:Rm],31, 1);
		} else {
			_shifter_operand = 0xFFFFFFFF;
			_shifter_carry_out = get_bits([_core readReg:Rm],31, 1);
		}
	} else {
		_shifter_operand = asr([_core readReg:Rm], shift_imm, 32);
		_shifter_carry_out = get_bits([_core readReg:Rm],shift_imm-1,1);
	}

	return 0;
}

+(UWord)bitmask {
	        return 0x0e000070;
}

+(UWord)testmask {
	        return 0x00000040;
}


@end

