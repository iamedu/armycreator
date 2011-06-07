#import <armyc/ARMCoproc.h>

@implementation ARMCoproc 

-(id)initWithCore:(ARMCore *)c {
	core = c;
	return self;
}

-(Word)executeCdp:(Word)instcode withAddr:(ARMAddressing *)addr {
	return -1;
}

-(Word)executeLdc:(Word)instcode withAddr:(ARMAddressing *)addr {
	return -1;
}

-(Word)executeMcr:(Word)instcode withAddr:(ARMAddressing *)addr {
	return -1;
}

-(Word)executeMcrr:(Word)instcode withAddr:(ARMAddressing *)addr {
	return -1;
}

-(Word)executeMrc:(Word)instcode withAddr:(ARMAddressing *)addr {
	return -1;
}

-(Word)executeMrrc:(Word)instcode withAddr:(ARMAddressing *)addr {
	return -1;
}

-(Word)executeStc:(Word)instcode withAddr:(ARMAddressing *)addr {
	return -1;
}


@end

