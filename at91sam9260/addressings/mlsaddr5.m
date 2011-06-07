#import <addrs/mlsaddr.h>

@implementation MLSAddr5

-(Word)execute {
	Word U;
	Word Rn;
	Word offset_8;
	Word immedH;
	Word immedL;

	U = get_bits(_instcode, 23, 1);
        Rn = get_bits(_instcode, 16, 4);
        immedH = get_bits(_instcode, 8, 4);
        immedL = get_bits(_instcode, 0, 4);
        _address = [_core readReg:Rn];
        offset_8 = ( immedH << 4 ) | immedL;
	
	if( cond(_core, _instcode) )
                if( U )
			[_core writeReg:Rn value:[_core readReg:Rn] + offset_8];
                else
			[_core writeReg:Rn value:[_core readReg:Rn] - offset_8];
}

+(UWord)bitmask {
	        return 0x0f600090;
}

+(UWord)testmask {
	        return 0x00400090;
}


@end

