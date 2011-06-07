#include <insts/ldc.h>
#import <armyc/ARMCoproc.h>

@implementation LdcInstruction

-(Word)execute {
	LSCAddr *addressing;
        Word cp_num;
        ARMCoproc *coproc;

        if(!cond(_core, _instcode))
                return 0;

        addressing = (LSCAddr *)[self fetch:_instcode];
        cp_num = get_bits(_instcode, 8, 4);


        if(addressing == (LSCAddr *)Nil)
                return -1;

        coproc = (ARMCoproc *)[_core getCoprocAt:cp_num];

        [coproc executeLdc:_instcode withAddr:addressing];
	
	return 0;

}

+(UWord)bitmask {
	return 0x0e100000;
}

+(UWord)testmask {
	return 0x0c100000;
}

@end

