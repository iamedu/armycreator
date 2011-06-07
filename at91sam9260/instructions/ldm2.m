#include <insts/ldm2.h>

@implementation Ldm2Instruction

-(Word)execute {
	LSMAddr *addressing;
        UWord address;
        Word register_list,i;

        addressing = (LSMAddr *)[self fetch:_instcode];

        if(addressing == (LSMAddr *)Nil)
                return -1;

        register_list = get_bits(_instcode, 0, 15);

        [addressing execute];

        address = [addressing start_address];

        for( i = 0; i < 15; i++)
                if( get_bits(register_list, i, 1) ){
                        [_core writeReg:i value:[_core readWordAt:address]];
                        address += 4;
                }
        if([addressing end_address] != address - 4 )
                exit(1);

	return 0;

}

+(UWord)bitmask {
	return 0x0e708000;
}

+(UWord)testmask {
	return 0x08500000;
}

@end

