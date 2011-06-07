#include <insts/msrr.h>

@implementation MsrrInstruction

-(Word)execute {
	UWord mask;
	Word operand;
	Word _bit_immediate;
	Word rotate_imm;
	Word Rm;
	Word field_mask;
	Word R;
	Word status_mode;
	Word byte1;
	Word byte2;
	Word byte3;
	Word byte4;
	Word byte_mask;

	if(!cond(_core, _instcode)) {
		return 0;
	}

	_bit_immediate = get_bits(_instcode, 0, 8);
        rotate_imm = get_bits(_instcode, 8, 4);
        Rm = get_bits(_instcode, 0, 4);
        field_mask = get_bits(_instcode, 16, 4);
        R = get_bits(_instcode, 22, 1);
	
	if( get_bits(_instcode, 25, 1)) {
		operand = ror32(_bit_immediate, rotate_imm * 2);
	} else {
		operand = Rm;
	}

	if( get_bits(field_mask, 0, 1) ) byte1 = 0x000000FF; else byte1 = 0x00000000;
        if( get_bits(field_mask, 1, 1) ) byte2 = 0x0000FF00; else byte2 = 0x00000000;
        if( get_bits(field_mask, 2, 1) ) byte3 = 0x00FF0000; else byte3 = 0x00000000;
        if( get_bits(field_mask, 3, 1) ) byte4 = 0xFF000000; else byte4 = 0x00000000;

	byte_mask = byte1 | byte2 | byte3 | byte4;

	status_mode = [_core statusFor:status_m];

	if(!R) {
		if( status_mode == mode_fiq || status_mode == mode_irq || status_mode == mode_svc || status_mode == mode_abt || status_mode == mode_und ) {
			if( (operand & 0x01000020) == 0){
				mask = byte_mask & (0xF8000000 | 0x0000000F);
			}
		} else {
			mask = byte_mask & 0xF8000000;
		}
		[_core setCpsr:(([_core cpsr] & ~mask) | (operand & mask))];
	} else {
		if([_core hasSpsr]) {
			mask = byte_mask & (0xF8000000 | 0x0000000F | 0x01000020);
			[_core setCpsr:(([_core cpsr] & ~mask) | (operand & mask))];
		}
	}
		


	return 0;
}

+(UWord)bitmask {
	return 0x0fa0fff0;
}

+(UWord)testmask {
	return 0x0120f000;
}

@end

