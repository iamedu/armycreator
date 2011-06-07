#ifndef _ARMYC_ARMCOPROC_H_
#define _ARMYC_ARMCOPROC_H_

#import <Chiles/ChObject.h>
#import <Chiles/ChTypes.h>
#import <armyc/ARMCore.h>
#import <armyc/ARMAddressing.h>

@interface ARMCoproc : ChObject {
	ARMCore *core;
}

-(id)initWithCore:(ARMCore *)c;

-(Word)executeCdp:(Word)instcode withAddr:(ARMAddressing *)addr;
-(Word)executeLdc:(Word)instcode withAddr:(ARMAddressing *)addr;
-(Word)executeMcr:(Word)instcode withAddr:(ARMAddressing *)addr;
-(Word)executeMcrr:(Word)instcode withAddr:(ARMAddressing *)addr;
-(Word)executeMrc:(Word)instcode withAddr:(ARMAddressing *)addr;
-(Word)executeMrrc:(Word)instcode withAddr:(ARMAddressing *)addr;
-(Word)executeStc:(Word)instcode withAddr:(ARMAddressing *)addr;

@end

#endif

