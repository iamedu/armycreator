#include <insts/ldrd.h>

@implementation LdrdInstruction

-(Word)execute {
	/*MLSAddr *addressing;
        Word Rd, cp15_reg1;
        ARMCoproc *coproc;

        if(!cond(_core, _instcode))
                return 0;

        addressing = (MLSAddr *)[self fetch:_instcode];
        Rd = get_bits(_instcode, 12, 4);

        if(addressing == (LSCAddr *)Nil)
                return -1;

        coproc = (ARMCoproc *)[_core getCoprocAt:15];
	cp15_reg1 = [coproc readReg:]

        [coproc executeMls:_instcode withAddr:addressing];
	return 0;
	//-------------------
	ARMAddr *modes = addr_modes_mls();
        ARMAddr *mode;
        ARMAddrMLSReturn result;
        ARMCoprocessorInterface *cp15;
        Word Rd, cp15_reg1;

        if( !cond(proc, instruction) )
                return;
        mode = fetch_addr(modes, instruction);
        Rd = get_bits(instruction, 12, 4);
        if(mode != NULL)
                 mode->execute(proc, instruction, &result);
        cp15  = proc->coprocessors[15];
        cp15_reg1 = cp15->readRegister(cp15, 1);
        if( Rd % 2 && Rd != 14 && !get_bits(result.address, 0, 2) && (get_bits(cp15_reg1, 22, 1)  || !get_bits(result.address, 2, 1)) ) {
                *proc->r[Rd] = proc->readWord(proc, result.address);
                *proc->r[Rd + 1] = proc->readWord(proc, result.address + 4);
        }*/

}

+(UWord)bitmask {
	return 0x0e1000f0;
}

+(UWord)testmask {
	return 0x000000d0;
}

@end

