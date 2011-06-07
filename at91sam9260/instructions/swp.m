#include <insts/swp.h>

@implementation SwpInstruction

-(Word)execute {
        Word cp15_reg1;
	Word temp;
	Word address;
	Word Rm;
	Word Rd;

	if( !cond(_core, _instcode) )
                return 0;
	
        address = [_core readReg:get_bits(_instcode, 16, 4)];
        Rm = get_bits(_instcode, 0, 4);
        Rd = get_bits(_instcode, 12, 4);
	cp15_reg1 = 0;
        if( !get_bits(cp15_reg1, 22, 1) ){
                temp = ror32([_core readWordAt:address], 8 * get_bits(address, 0, 2));
		[_core writeWord:[_core readReg:Rm] at:address];
		[_core writeReg:Rd value:temp];
        }else{
		temp = [_core readWordAt:address];
		[_core writeWord:[_core readReg:Rm] at:address];
		[_core writeReg:Rd value:temp];
        }

	return 0;
}

+(UWord)bitmask {
	return 0x0ff00ff0;
}

+(UWord)testmask {
	return 0x01000090;
}

@end

