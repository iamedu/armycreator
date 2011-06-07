#import <addrs/lsaddr.h>
#import <armyc/utils.h>

@implementation LSAddr6

-(Word)execute {
	Word shift, shift_imm, Rm, index, U, Rn;
	shift = get_bits(_instcode, 5, 2);
        shift_imm = get_bits(_instcode, 7, 5);
        Rm = get_bits(_instcode, 0, 4);
        U = get_bits(_instcode, 23, 1);
        Rn = get_bits(_instcode, 16, 4);
        switch(shift){
                case 0:
                        index = [_core readReg:Rm] << shift_imm;
                        break;
                case 1:
                        if(shift_imm == 0)
                                index = 0;
                        else
                                index = [_core readReg:Rm] >> shift_imm;
                        break;
                case 2:
                        if(shift_imm == 0)
                                if(get_bits(Rm, 31, 1) == 1)
                                        index = 0xffffffff;
                                else
                                        index = 0;
                        else
                                index = asr32([_core readReg:Rm], shift_imm);
                        break;
                case 3:
                        if(shift_imm == 0)
                                index = (get_bits([_core readReg:[_core cpsr]],29,1) << 31) | ([_core readReg:Rm] >> 1);
                        else
                                index = ror32(Rm, shift_imm);
                        break;
                default:
                        break;
        }

        if( U )
                _address = [_core readReg:Rn] + index;
        else
                _address = [_core readReg:Rn] - index;
        if( cond(_core, _instcode) )
		[_core writeReg:Rn value:_address];

	return 0;
}

+(UWord)bitmask {
	        return 0x0f200010;
}

+(UWord)testmask {
	        return 0x07200000;
}


@end

