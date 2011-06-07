#ifndef _ADDR_LSMADDR_H_
#define _ADDR_LSMADDR_H_

#import <armyc/ARMAddressing.h>

@interface LSMAddr : ARMAddressing {
	Word _start_address;
	Word _end_address;
}

-(Word)start_address;
-(Word)end_address;

@end

@interface LSMAddr1 : LSMAddr {
}
@end

@interface LSMAddr2 : LSMAddr {
}
@end

@interface LSMAddr3 : LSMAddr {
}
@end

@interface LSMAddr4 : LSMAddr {
}
@end

#endif

