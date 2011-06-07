#include <insts/ls.h>

#include <addrs/lsaddr.h>

@implementation LsInstruction

-(id)initWithInstcode:(UWord)instcode core:(ARMCore *)core {
	self = [super initWithInstcode:instcode core:core];

	addrs = [[ChList alloc] init];

	[addrs insert:(id)[LSAddr1 class]];
	[addrs insert:(id)[LSAddr2 class]];
	[addrs insert:(id)[LSAddr3 class]];
	[addrs insert:(id)[LSAddr4 class]];
	[addrs insert:(id)[LSAddr5 class]];
	[addrs insert:(id)[LSAddr6 class]];
	[addrs insert:(id)[LSAddr7 class]];
	[addrs insert:(id)[LSAddr8 class]];
	[addrs insert:(id)[LSAddr9 class]];

	return self;
}



@end

