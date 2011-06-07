#include <insts/ldr.h>

@implementation LdrInstruction

-(Word)execute {
	Word data,
	     Rd,
	     cp15_reg1;

	LSAddr *addr;

        if( !cond(_core, _instcode) )
                return;
	//mode = fetch_addr(modes, instruction);
	addr = (LSAddr *)[self fetch:_instcode];

	
	if(addr  == (LSAddr *)Nil) {
		return -1;
	}

	Rd = get_bits(_instcode, 12, 4);

	[addr execute];

	/*
	cp15  = proc->coprocessors[15];
        cp15_reg1 = cp15->readRegister(cp15, 1);
        if( !get_bits(cp15_reg1, 22, 1) )
                data = ror32(proc->readWord(proc, result.address), (8 * get_bits(result.address, 0, 1)));
        else*/
                data = [_core readWordAt:[addr address]];
        if( Rd == 15 ){
		//if (ARMv5 or above) then
			[_core writeReg:15 value:data & 0xFFFFFFFE];
			[_core setStatus:get_bits(data, 0 ,1)
			         forFlag:status_t];
		/*
	        else
	                *proc->r[15] = data & 0xFFFFFFFC;
   	        */
	} else
		[_core writeReg:Rd value:data];
	return 0;
}

+(UWord)bitmask {
	return 0x0c500000;
}

+(UWord)testmask {
	return 0x04100000;
}

@end

