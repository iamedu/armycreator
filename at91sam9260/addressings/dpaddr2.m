#import <addrs/dpaddr.h>

@implementation DPAddr2

-(Word)execute {
	Word Rm;
	Word Cflag;

	Rm = get_bits(_instcode, 0, 4);
	Cflag = get_bits([_core cpsr], 29, 1);

	_shifter_operand = [_core readReg:Rm];
	_shifter_carry_out = Cflag;

	return 0;
}

+(UWord)bitmask {
	        return 0x0e000ff0;
}

+(UWord)testmask {
	        return 0x00000000;
}


@end

