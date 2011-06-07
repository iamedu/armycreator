#import <addrs/dpaddr.h>

@implementation DPAddr3

-(Word)execute {
	Word Rm;
	Word Cflag;
	Word shift_imm;

	Rm = get_bits(_instcode,0,4);
	Cflag =  get_bits([_core cpsr], 29, 1);
	shift_imm = get_bits(_instcode, 7, 5);

	if(shift_imm == 0) {
		_shifter_operand = [_core readReg:Rm];
		_shifter_carry_out = Cflag;
	} else {
		_shifter_operand = [_core readReg:Rm] << shift_imm;
		_shifter_carry_out = get_bits([_core readReg:Rm],
		                     32 - shift_imm, 1);
	}

	return 0;
}

+(UWord)bitmask {
	        return 0x0e000070;
}

+(UWord)testmask {
	        return 0x00000000;
}


@end

