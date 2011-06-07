#import <addrs/lscaddr.h>

@implementation LSCAddr2

-(Word)execute {
	Word val;
        Word U = get_bits(_instcode,23,1);
        Word Rn = get_bits(_instcode,16,4);
        Word offset_8 = get_bits(_instcode,0,8);
        if(cond(_core, _instcode)){
                if(U == 1){
                        val  = [_core readReg:Rn] + offset_8 * 4;
			[_core writeReg:Rn value:val];
                }
                else{
                        val  = [_core readReg:Rn] - offset_8 * 4;
			[_core writeReg:Rn value:val];
                }
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
	        return 0x0d200000;
}


@end

