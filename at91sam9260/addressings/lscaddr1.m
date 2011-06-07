#import <addrs/lscaddr.h>

@implementation LSCAddr1

-(Word)execute {
        Word U = get_bits(_instcode,23,1);
        Word Rn = get_bits(_instcode,16,4);
        Word offset_8 = get_bits(_instcode ,0,8);
        if(cond(_core, _instcode)){
                if(U == 1){
                        _address = [_core readReg:Rn] + offset_8 * 4;
                }
                else{
                        _address = [_core readReg:Rn] - offset_8 * 4;
                }
        _start_address = _address;
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
	        return 0x0d000000;
}


@end

