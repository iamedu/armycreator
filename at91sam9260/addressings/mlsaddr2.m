#import <addrs/mlsaddr.h>

@implementation MLSAddr2

-(Word)execute {
	Word U;
	Word Rn;
	Word Rm;
	
        U = get_bits(_instcode, 23, 1);
        Rn = get_bits(_instcode, 16, 4);
        Rm = get_bits(_instcode, 0, 4);
	
        if( U )
		_address = [_core readReg:Rn] + [_core readReg:Rm];
        else
		_address = [_core readReg:Rn] - [_core readReg:Rm];
}

+(UWord)bitmask {
	        return 0x0f600f90;
}

+(UWord)testmask {
	        return 0x01000090;
}


@end

