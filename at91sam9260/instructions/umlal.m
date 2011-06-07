#include <insts/umlal.h>

@implementation UmlalInstruction

-(Word)execute {
	UWord RdLo = get_bits(_instcode,12,4);
        UWord RdHi = get_bits(_instcode,16,4);
        Word Rs = get_bits(_instcode,8,4);
        Word Rm = get_bits(_instcode,0,4);
        Word S = get_bits(_instcode,20,1);
        Word carry;
        Word result;
        Word z;
        Word Hi;
        Word Lo;
	if(!cond(_core, _instcode))
                return 0;
        Mul64([_core readReg:Rm], [_core readReg:Rs], &Hi, &Lo);
	[_core writeReg:RdLo value:AddCarryFrom(Lo, [_core readReg:RdLo], &carry)];
	[_core writeReg:RdHi value:Hi + [_core readReg:RdHi] + carry];
        if(S == 1){
        	[_core setStatus:get_bits([_core readReg:RdHi],31,1)
		         forFlag:status_n];
                if([_core readReg:RdHi] == 0 && [_core readReg:RdLo] == 0)
                	z = 1;
                else
                	z = 0;
                [_core setStatus:z forFlag:status_z];
	}
	
	return 0;
}

+(UWord)bitmask {
	return 0x0fe000f0;
}

+(UWord)testmask {
	return 0x00a00090;
}

@end

