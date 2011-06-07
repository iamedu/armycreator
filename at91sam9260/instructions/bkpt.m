#include <insts/bkpt.h>

@implementation BkptInstruction

-(Word)execute {
	Word immed_16;
        Word immed_4;
        Word immed_12;

        immed_4 = get_bits(_instcode, 0, 4);
        immed_12 = get_bits(_instcode, 8, 12);

        immed_16 = immed_4 | ( (immed_12 << 4) & 0xfff0 );

        //printf("bkpt: %d\n", immed_16);

        //pauseExecution([_core], proc->thread);
	[_core pause];

	return 0;
}

+(UWord)bitmask {
	return 0xfff000f0;
}

+(UWord)testmask {
	return 0xe1200070;
}

@end

