#include <insts/ldm1.h>

@implementation Ldm1Instruction

-(Word)execute {

	LSMAddr *addressing;
	UWord address;
	Word register_list, values,i;

        addressing = (LSMAddr *)[self fetch:_instcode];

        if(addressing == (LSMAddr *)Nil)
                return -1;
        
	register_list = get_bits(_instcode, 0, 16);

        [addressing execute];
	
	address = [addressing start_address];

	for( i = 0; i < 15; i++)
                if( get_bits(register_list, i, 1) ){
			[_core writeReg:i value:[_core readWordAt:address]];
                        address += 4;
                }
        if( get_bits(register_list, 15, 1) ){
                values = [_core readWordAt:address];
		[_core writeReg:15 value:(values & 0xFFFFFFFE)];
                set_bits([_core cpsr], 5, 1, get_bits(values, 0, 1));
                address += 4;
        }
        if([addressing end_address] != address - 4 )
                exit(1);

        return 0;
}

+(UWord)bitmask {
	return 0x0e500000;
}

+(UWord)testmask {
	return 0x08100000;
}

@end

