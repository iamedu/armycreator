#import <addrs/lsaddr.h>
#import <armyc/utils.h>

@implementation LSAddr2

-(Word)execute {
	Word Rn, Rm, U;
	U = get_bits(_instcode, 23, 1);
        Rn = get_bits(_instcode, 16, 4);
        Rm = get_bits(_instcode, 0, 4);

        if( U )
                _address = [_core readReg:Rn] + [_core readReg:Rm];
        else
                _address = [_core readReg:Rn] - [_core readReg:Rm];
	return 0;
}

+(UWord)bitmask {
	        return 0x0f200ff0;
}

+(UWord)testmask {
	        return 0x07000000;
}


@end

