#include <insts/swpb.h>

@implementation SwpbInstruction

-(Word)execute {
	Word temp;
	Word address;
	Word Rm;
	Word Rd;
	
        if( !cond(_core, _instcode) )
                return;
	
        address = [_core readReg:get_bits(_instcode, 16, 4)];
        Rm = get_bits(_instcode, 0, 4);
        Rd = get_bits(_instcode, 12, 4);
        temp = [_core readByteAt:address];
	[_core writeByte:get_bits([_core readReg:Rm], 0, 8) at:address];
	[_core writeReg:Rd value: temp];
	
	return 0;
}

+(UWord)bitmask {
	return 0x0ff00ff0;
}

+(UWord)testmask {
	return 0x01400090;
}

@end

