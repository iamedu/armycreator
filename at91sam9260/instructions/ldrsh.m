#include <insts/ldrsh.h>

@implementation LdrshInstruction

-(Word)execute {
	return 0;
	//Instrucciones de MLS
        /* ARMAddr *modes = addr_modes_mls();
        ARMAddr *mode;
        ARMAddrMLSReturn result;
        ARMCoprocessorInterface *cp15;
        Word data, cp15_reg1, Rd;

        if( !cond(proc, instruction) )
                return;
        mode = fetch_addr(modes, instruction);

        if(mode != NULL)
                mode->execute(proc, instruction, &result);
        cp15  = proc->coprocessors[15];
        cp15_reg1 = cp15->readRegister(cp15, 1);
        Rd = get_bits(instruction, 12, 4);
        if( !get_bits(cp15_reg1, 22, 1) )
                if( !get_bits(result.address,0,1) )
                        data = proc->readHalfword(proc,result.address);
        else
                data = proc->readHalfword(proc,result.address);
        *proc->r[Rd] = SignExtend(data & 0x0000ffff);*/

}

+(UWord)bitmask {
	return 0x0e1000f0;
}

+(UWord)testmask {
	return 0x001000f0;
}

@end

