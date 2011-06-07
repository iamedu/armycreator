#import <addrs/lsaddr.h>

@implementation LSAddr8

-(Word)execute {
	Word Rn, U, Rm, val;

        U = get_bits(_instcode, 23, 1);
        Rn = get_bits(_instcode, 16, 4);
        Rm = get_bits(_instcode, 0, 4);

        _address = [_core readReg:Rn];
        if( cond(_core, _instcode) ){
                if( U ){
			val = [_core readReg:Rn] + Rm;
			[_core writeReg:Rn value:val];
		}
                else{
			val = [_core readReg:Rn] - Rm;
			[_core writeReg:Rn value:val];
		}
	}
	return 0;
}

+(UWord)bitmask {
	        return 0x0f200ff0;
}

+(UWord)testmask {
	        return 0x06000000;
}


@end

