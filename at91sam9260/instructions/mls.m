#include <insts/mls.h>

#include <addrs/mlsaddr.h>

@implementation MlsInstruction

-(id)initWithInstcode:(UWord)instcode core:(ARMCore *)core {
	self = [super initWithInstcode:instcode  core:core];

	addrs = [[ChList alloc] init];

	[addrs insert:(id)[MLSAddr1 class]];
	[addrs insert:(id)[MLSAddr2 class]];
	[addrs insert:(id)[MLSAddr3 class]];
	[addrs insert:(id)[MLSAddr4 class]];
	[addrs insert:(id)[MLSAddr5 class]];
	[addrs insert:(id)[MLSAddr6 class]];

	return self;
}



@end

