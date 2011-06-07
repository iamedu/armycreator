#include <insts/dp.h>

#include <addrs/dpaddr.h>

@implementation DpInstruction

-(id)initWithInstcode:(UWord)instcode core:(ARMCore *)core {
	self = [super initWithInstcode:instcode core:core];

	addrs = [[ChList alloc] init];

	[addrs insert:(id)[DPAddr1 class]];
	[addrs insert:(id)[DPAddr2 class]];
	[addrs insert:(id)[DPAddr3 class]];
	[addrs insert:(id)[DPAddr4 class]];
	[addrs insert:(id)[DPAddr5 class]];
	[addrs insert:(id)[DPAddr6 class]];
	[addrs insert:(id)[DPAddr7 class]];
	[addrs insert:(id)[DPAddr8 class]];
	[addrs insert:(id)[DPAddr11 class]];
	[addrs insert:(id)[DPAddr9 class]];
	[addrs insert:(id)[DPAddr10 class]];

	return self;
}



@end

