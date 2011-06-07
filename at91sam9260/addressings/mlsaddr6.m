#import <addrs/mlsaddr.h>

@implementation MLSAddr6

-(Word)execute {
	Word U;
	Word Rn;
	Word Rm;

	U = get_bits(_instcode, 23, 1);
	Rn = get_bits(_instcode, 16, 4);
	Rm = get_bits(_instcode, 0, 4);
	_address = [_core readReg:Rn];
	
	if( cond(_core, _instcode) )
		if( U )
			[_core writeReg:Rn value:[_core readReg:Rn] + Rm];
		else
			[_core writeReg:Rn value:[_core readReg:Rn] - Rm];
}

+(UWord)bitmask {
	return 0x0f600f90;
}

+(UWord)testmask {
	return 0x00000090;
}


@end

