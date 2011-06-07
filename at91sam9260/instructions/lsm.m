#include <insts/lsm.h>
#include <addrs/lsmaddr.h>

@implementation LsmInstruction

-(id)initWithInstcode:(UWord)instcode core:(ARMCore *)core {
	self = [super initWithInstcode:instcode core:core];

	addrs = [[ChList alloc] init];

	[addrs insert:(id)[LSMAddr1 class]];
	[addrs insert:(id)[LSMAddr2 class]];
	[addrs insert:(id)[LSMAddr3 class]];
	[addrs insert:(id)[LSMAddr4 class]];

	return self;
}



@end

