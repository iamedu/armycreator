#include <insts/blx.h>

@implementation BlxInstruction

-(Word)execute {
	Word Rm, target;
        if(!cond(_core, _instcode)) {
                return 0;
        }  
	Rm = get_bits(_instcode, 0, 4);
        target = Rm;
	[_core writeReg:14 value:([_core readReg:15] + 4)];
        //*proc->r[14] = *proc->r[15] + 4;
	
	[_core setStatus:get_bits(target, 0, 1) forFlag:status_t];
        //set_status( proc, status_t, get_bits(target, 0, 1) );
	
	[_core writeReg:15 value:(target & 0xFFFFFFFE)];
        //*proc->r[15] = target & 0xFFFFFFFE;

	return 0;
}

+(UWord)bitmask {
	return 0x0ffffff0;
}

+(UWord)testmask {
	return 0x012fff30;
}

@end

