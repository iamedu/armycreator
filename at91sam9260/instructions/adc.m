#include <insts/adc.h>

@implementation AdcInstruction

-(Word)execute {
	DPAddr *addressing;
	Word S;
        Word Rn;
        Word Rd;
        Word carry;
        Word last_rd;

	addressing = (DPAddr *)[self fetch:_instcode];

	if(addressing == (DPAddr *)Nil)
                return -1;


        S =  get_bits(_instcode,20,1);
        Rn = get_bits(_instcode,16,4);
        Rd = get_bits(_instcode,12,4);

	
        [addressing execute];

        last_rd = [_core readReg:Rd];
        [_core writeReg:Rd value:AddCarryFrom([_core readReg:Rn], [addressing shifter_operand] + get_bits([_core cpsr],29,1),&carry)];

        if(S && Rd == 15) {
		if([_core hasSpsr]) {
                        [_core setCpsr:[_core spsr]];
                }
        } else if(S == 1) {
			[_core setStatus:get_bits([_core readReg:Rd], 31, 1) forFlag:[_core statusFor:status_n]];
                        [_core setStatus:([_core readReg:Rd] == 0) forFlag:[_core statusFor:status_z]];
			[_core setStatus:carry forFlag:[_core statusFor:status_c]];
			[_core setStatus:OverflowFrom(last_rd + [addressing shifter_operand], get_bits([_core cpsr], 29, 1),[_core readReg:Rd]) forFlag:[_core statusFor:status_n]];
        }

	return 0;
}

+(UWord)bitmask {
	return 0x0de00000;
}

+(UWord)testmask {
	return 0x00a00000;
}

@end

