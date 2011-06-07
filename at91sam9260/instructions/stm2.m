#include <insts/stm2.h>

@implementation Stm2Instruction

-(Word)execute {
	LSMAddr *addressing;
	Word address;
	Word register_list;
        int i;

	addressing = (LSMAddr *)[self fetch:_instcode];
        if(addressing == (LSMAddr *)Nil)
                return -1;

        [addressing execute];

        if(!cond(_core, _instcode))
                return 0;

        register_list = get_bits(_instcode, 0, 16);
        address = [addressing start_address];
        for( i = 0; i < 16; i++ )
                if( get_bits(register_list, i, 1) ){
			[_core writeWord:[_core readRegUsr:i] at:address];
                        address += 4;
                }
        if( [addressing end_address] != address - 4 )
                return -1;
	return 0;
}

+(UWord)bitmask {
	return 0x0e700000;
}

+(UWord)testmask {
	return 0x08400000;
}

@end

