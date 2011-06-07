#include <insts/lsc.h>
#include <addrs/lscaddr.h>

@implementation LscInstruction

-(id)initWithInstcode:(UWord)instcode core:(ARMCore *)core {
	self = [super initWithInstcode:instcode core:core];

	addrs = [[ChList alloc] init];

	[addrs insert:(id)[LSCAddr1 class]];
	[addrs insert:(id)[LSCAddr2 class]];
	[addrs insert:(id)[LSCAddr3 class]];
	[addrs insert:(id)[LSCAddr4 class]];

	return self;
}



@end

