#ifndef _ADDR_LSCADDR_H_
#define _ADDR_LSCADDR_H_

#import <armyc/ARMAddressing.h>

@interface LSCAddr : ARMAddressing {
	Word _address;
	Word _start_address;
	Word _end_address;
}

-(Word)address;
-(Word)start_address;
-(Word)end_address;

@end

@interface LSCAddr1 : LSCAddr {
}
@end

@interface LSCAddr2 : LSCAddr {
}
@end

@interface LSCAddr3 : LSCAddr {
}
@end

@interface LSCAddr4 : LSCAddr {
}
@end

#endif

