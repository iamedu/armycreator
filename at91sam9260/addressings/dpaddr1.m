#import <addrs/dpaddr.h>
#import <armyc/utils.h>

@implementation DPAddr1

-(Word)execute {
	Word immed_8;
	Word rotate_imm;
	Word Cflag;

	immed_8 = get_bits(_instcode, 0, 8);
	rotate_imm = get_bits(_instcode, 8, 8);
	Cflag = get_bits([_core cpsr], 29, 1);

	_shifter_operand = ror(immed_8, 32, rotate_imm * 2);

	if(rotate_imm == 0) {
		_shifter_carry_out = Cflag;
	} else {
		_shifter_carry_out = get_bits(_shifter_operand, 31, 1);
	}

}

+(UWord)bitmask {
	        return 0x0e000000;
}

+(UWord)testmask {
	        return 0x02000000;
}

@end

