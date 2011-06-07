#import <addrs/lsmaddr.h>
#import <armyc/utils.h>

@implementation LSMAddr1

-(Word)execute {
	Word Rn;
	Word register_list;
	Word W;

        Rn = get_bits(_instcode, 16, 4);
        register_list = get_bits(_instcode, 0, 16);
        W = get_bits(_instcode, 21, 1);
        _start_address = [_core readReg:Rn];
        _end_address = [_core readReg:Rn] + (count32(register_list) * 4) - 4;

        if( cond(_core, _instcode) && W )
		[_core writeReg:Rn value:[_core readReg:Rn] + (count32(register_list) * 4)];
}

+(UWord)bitmask {
	        return 0x0f800000;
}

+(UWord)testmask {
	        return 0x08800000;
}


@end

