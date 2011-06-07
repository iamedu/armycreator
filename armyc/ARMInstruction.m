#import <armyc/ARMInstruction.h>
#import <Chiles/ChString.h>
#import <Chiles/ChInteger.h>
#import <string.h>

@implementation ARMInstruction 

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

+(BOOL)isInstruction:(UWord)instcode {
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

	desc = [className concat:@" instruction at "];
	desc = [desc concat:chaddr];
	desc = [desc concat:@": "];
	desc = [desc concat:value];

	return desc;
}

-(id)fetch:(UWord)instcode {
	ChObject<Iterator> *it = [addrs iterator];
	ARMAddressing *addressing;
	Class class;
	int result;

	addressing = addrCache;

	if(addressing != Nil) {
		[_core debug:@"Fetched: %@\n", addressing];
		[it release];
		return addressing;
	}

	while([it hasNext]) {
		class = (Class)[it next];
		result = (BOOL)[class isAddressing:instcode];
		if(result) {
			addressing = [[class alloc] initWithInstcode:instcode
			                            core:_core];
			addrCache = addressing;
			[_core debug:@"Fetched: %@\n", addressing];
			[it release];
			return addressing;
		}
	}
	
	[it release];

	return Nil;
}

@end

