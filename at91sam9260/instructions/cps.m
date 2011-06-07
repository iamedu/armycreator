#include <insts/cps.h>

//Implemnted in ARMV6 DO NOT IMPLEMENT

@implementation CpsInstruction

-(Word)execute {
	return 0;
}

+(UWord)bitmask {
	return 0xfff1fd20;
}

+(UWord)testmask {
	return 0xf1000000;
}

@end

