#ifndef _ARMYC_ARMINSTRUCTION_H_
#define _ARMYC_ARMINSTRUCTION_H_

#import <Chiles/ChTypes.h>
#import <Chiles/ChObject.h>
#import <armyc/ARMCore.h>
#import <armyc/ARMAddressing.h>
#import <armyc/utils.h>

#define RES_EX 1
#define UND_EX 2
#define SWI_EX 3
#define PFA_EX 4
#define DTA_EX 5
#define INT_EX 7
#define FIQ_EX 8

@interface ARMInstruction : ChObject {
	UWord _instcode;
	ARMCore *_core;
	ChList *addrs;
	ARMAddressing *addrCache;
}

-(id)initWithInstcode:(UWord)instcode core:(ARMCore*)core;
-(Word)execute;
+(UWord)bitmask;
+(UWord)testmask;
+(BOOL)isInstruction:(UWord)instcode;
-(id)fetch:(UWord)instcode;

@end

#endif

