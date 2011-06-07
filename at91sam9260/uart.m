#import <uart.h>

@implementation Uart

-(id)initWithBase:(UWord)b withCore:(ARMCore *)c {
	self = [self initWithSize:1 withCore:c withBase:b];
	return self;
}


-(void)run {
}

@end

