#ifndef _ARMYC_ARMADDRESSING_H_
#define _ARMYC_ARMADDRESSING_H_

#import <Chiles/ChTypes.h>
#import <Chiles/ChObject.h>
#import <armyc/ARMCore.h>
#import <armyc/utils.h>

@interface ARMAddressing : ChObject {
	UWord _instcode;
	ARMCore *_core;
}

-(id)initWithInstcode:(UWord)instcode core:(ARMCore*)core;
-(Word)execute;
+(UWord)bitmask;
+(UWord)testmask;
+(BOOL)isAddressing:(UWord)instcode;

@end

#endif

