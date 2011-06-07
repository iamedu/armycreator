#ifndef _ADDR_DPADDR_H_
#define _ADDR_DPADDR_H_

#import <armyc/ARMAddressing.h>

@interface DPAddr : ARMAddressing {
	UWord _shifter_operand;
	UWord _shifter_carry_out;
}

-(UWord)shifter_operand;
-(UWord)shifter_carry_out;

@end

@interface DPAddr1 : DPAddr {
}
@end

@interface DPAddr2 : DPAddr {
}
@end

@interface DPAddr3 : DPAddr {
}
@end

@interface DPAddr4 : DPAddr {
}
@end

@interface DPAddr5 : DPAddr {
}
@end

@interface DPAddr6 : DPAddr {
}
@end

@interface DPAddr7 : DPAddr {
}
@end

@interface DPAddr8 : DPAddr {
}
@end

@interface DPAddr9 : DPAddr {
}
@end

@interface DPAddr10 : DPAddr {
}
@end

@interface DPAddr11 : DPAddr {
}
@end


#endif

