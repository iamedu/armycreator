#import <addrs/dpaddr.h>

@implementation DPAddr11

-(Word)execute {
	Word Rm;
	Word Cflag;

	Rm = get_bits(_instcode, 0, 4);
	Cflag = get_bits([_core cpsr],29,1);

	_shifter_operand =  (Cflag << 31) | ([_core readReg:Rm] >> 1);
	_shifter_carry_out = get_bits([_core readReg:Rm],0,1);

	return 0;
}

+(UWord)bitmask {
	return 0x0e0000f0;
}

+(UWord)testmask {
	return 0x00000070;
}


@end

