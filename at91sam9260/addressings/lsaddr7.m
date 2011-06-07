#import <addrs/lsaddr.h>
#import <armyc/utils.h>

@implementation LSAddr7

-(Word)execute {
	Word Rn, U, offset_12, val;
	
        U = get_bits(_instcode, 23, 1);
        Rn = get_bits(_instcode, 16, 4);
        offset_12 = get_bits(_instcode, 0, 12);

        _address = [_core readReg:Rn];
        if( cond(_core, _instcode) ){
		val = [_core readReg:Rn] + offset_12;
                if( U ){
			[_core writeReg:Rn value:val];
                        
		}
                else{
			[_core writeReg:Rn value:val];
		}
	}

	return 0;
}

+(UWord)bitmask {
	        return 0x0f200000;
}

+(UWord)testmask {
	        return 0x04000000;
}


@end

