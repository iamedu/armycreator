#import <addrs/dpaddr.h>

@implementation DPAddr4

-(Word)execute {
	Word Rs;
	Word Rm;
	Word aux;
	Word Cflag;

	Rm = get_bits(_instcode, 0, 4);
	Rs = get_bits(_instcode, 4, 4);
	aux = get_bits([_core readReg:Rs],0,8);
	Cflag = get_bits([_core cpsr], 29, 1);

	if(aux==0){
                _shifter_operand = [_core readReg:Rm];
                _shifter_carry_out = Cflag;
        }else if(aux < 32){
                _shifter_operand = [_core readReg:Rm] << aux;
                _shifter_carry_out = get_bits([_core readReg:Rm], 32 - aux, 1);
        }else if(aux == 32){
                _shifter_operand = 0;
                _shifter_carry_out = get_bits([_core readReg:Rm], 0, 1);
        }else{/*aux > 32*/
                _shifter_operand = 0;
                _shifter_carry_out = 0;
        }

	return 0;
}

+(UWord)bitmask {
	        return 0x0e0000f0;
}

+(UWord)testmask {
	        return 0x00000010;
}


@end

