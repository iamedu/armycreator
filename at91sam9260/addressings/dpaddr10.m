#import <addrs/dpaddr.h>
#import <armyc/utils.h>

@implementation DPAddr10

-(Word)execute {
	Word Rm;
	Word Cflag;
	Word Rs;

	Rm = get_bits(_instcode, 0, 4);
	Cflag = get_bits([_core cpsr], 29, 1);
	Rs = get_bits(_instcode, 8, 4);

	if(get_bits([_core readReg:Rs], 0, 8) == 0) {
		_shifter_operand = [_core readReg:Rm];
		_shifter_carry_out = Cflag;
	} else if(get_bits([_core readReg:Rs], 0, 5) == 0) {
		_shifter_operand = [_core readReg:Rm];
		_shifter_carry_out = get_bits([_core readReg:Rm], 31, 1);
	} else {
		_shifter_operand = ror([_core readReg:Rm], 32,
		              get_bits([_core readReg:Rs], 0, 5));
		_shifter_carry_out = get_bits([_core readReg:Rm],
		                 get_bits([_core readReg:Rs], 0, 5) - 1,
				 1);
	}

	return 0;
}

+(UWord)bitmask {
	return 0x0e0000f0;
}

+(UWord)testmask {
	return 0x00000070;
}


@end

