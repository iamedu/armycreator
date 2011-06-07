#import <addrs/lscaddr.h>

@implementation LSCAddr4

-(Word)execute {
	Word U = get_bits(_instcode,23,1);
        Word Rn = get_bits(_instcode,16,4);
        Word offset_8 = get_bits(_instcode,0,8);
        if(cond(_core, _instcode)){
                _start_address = [_core readReg:Rn];
                _address = _start_address;
                while(1){//TODO EL WHILE
                        _address = _address + 4;
                }
                _end_address = _address;
        }

	return 0;
}

+(UWord)bitmask {
	        return 0x0f200000;
}

+(UWord)testmask {
	        return 0x0c000000;
}


@end

