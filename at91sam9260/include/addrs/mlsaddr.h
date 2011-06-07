#ifndef _ADDR_MLSADDR_H_
#define _ADDR_MLSADDR_H_

#import <armyc/ARMAddressing.h>

@interface MLSAddr : ARMAddressing {
	Word _address;
}

-(Word)address;

@end

@interface MLSAddr1 : MLSAddr {
}
@end

@interface MLSAddr2 : MLSAddr {
}
@end

@interface MLSAddr3 : MLSAddr {
}
@end

@interface MLSAddr4 : MLSAddr {
}
@end

@interface MLSAddr5 : MLSAddr {
}
@end

@interface MLSAddr6 : MLSAddr {
}
@end

#endif

