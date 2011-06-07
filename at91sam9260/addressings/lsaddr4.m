#import <addrs/lsaddr.h>
#import <armyc/utils.h>

@implementation LSAddr4

-(Word)execute {
	Word Rn, offset_12, U;

        U = get_bits(_instcode, 23, 1);
        Rn = get_bits(_instcode, 16, 4);
        offset_12 = get_bits(_instcode, 0, 12);

        if( U )
                _address = [_core readReg:Rn] + offset_12;
        else
                _address = [_core readReg:Rn] - offset_12;

        if( cond(_core, _instcode) )
                [_core writeReg:Rn value:_address];

	return 0;
}

+(UWord)bitmask {
	        return 0x0f200000;
}

+(UWord)testmask {
	        return 0x05200000;
}


@end

