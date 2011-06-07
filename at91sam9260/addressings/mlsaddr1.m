#import <addrs/mlsaddr.h>

@implementation MLSAddr1

-(Word)execute {
	Word U;
	Word Rn;
	Word immedH;
	Word immedL;
	Word offset_8;

        U = get_bits(_instcode, 23, 1);
        Rn = get_bits(_instcode, 16, 4);
        immedH = get_bits(_instcode, 8, 4);
        immedL = get_bits(_instcode, 0, 4);
        offset_8 = ( immedH << 4 ) | immedL;

        if( U )
		_address = [_core readReg:Rn] + offset_8;
        else
		_address = [_core readReg:Rn] - offset_8;
}

+(UWord)bitmask {
	        return 0x0f600090;
}

+(UWord)testmask {
	        return 0x01400090;
}


@end

