#import <armyc/ARMAddressing.h>
#import <Chiles/ChString.h>
#import <string.h>

@implementation ARMAddressing

-(id)initWithInstcode:(UWord)instcode core:(ARMCore *)core {
	_core = core;
	_instcode = instcode;

	return self;
}

-(Word)execute {
	return -1;
}

+(UWord)bitmask {
	return 0;
}

+(UWord)testmask {
	return 0;
}

+(BOOL)isAddressing:(UWord)instcode {
	int bitmask;
	int testmask;

	bitmask  = [self bitmask];
	testmask = [self testmask];

	return (instcode & bitmask) == testmask;
}

-(ChString *)description {
	ChString *desc;
	ChString *className;
	ChString *chaddr;
	ChString *value;
	char *caddr;
	char *cval;
	caddr = malloc(9);
	cval  = malloc(9);

	sprintf(caddr, "%x", self);
	sprintf(cval, "%x", _instcode);

	className = [[ChInmutableString alloc] initWithCString:(char *)isa->name];
	chaddr    = [[ChInmutableString alloc] initWithCString:caddr];
	value	  = [[ChInmutableString alloc] initWithCString:cval];

	desc = [className concat:@" addressing mode at "];
	desc = [desc concat:chaddr];
	desc = [desc concat:@": "];
	desc = [desc concat:value];

	return desc;
}

@end

