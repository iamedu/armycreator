#include <insts/mla.h>

@implementation MlaInstruction

-(Word)execute {
	Word Rm = get_bits(_instcode,0,4);
        Word Rd = get_bits(_instcode,16,4);
        Word Rs = get_bits(_instcode,8,4);
        Word Rn = get_bits(_instcode,12,4);
        Word S = get_bits(_instcode,20,0);

	UWord value;

        if(!cond(_core,_instcode)){
		value = [_core readReg:Rm] * [_core readReg:Rs] +
		        [_core readReg:Rn];
                [_core writeReg:Rd value:value]; 
                if(S == 1){
                        [_core setStatus:get_bits([_core readReg:Rd],31,1)
			       forFlag:status_n];
                        [_core setStatus:([_core readReg:Rd] == 0)
			       forFlag:status_z];
                }
        }

	return 0;
}

+(UWord)bitmask {
	return 0x0fe000f0;
}

+(UWord)testmask {
	return 0x00200090;
}

@end

