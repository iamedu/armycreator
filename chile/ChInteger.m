#import <Chiles/ChInteger.h>

@implementation ChInteger 

-(id)initFromInt:(int)i {
	self = [super init];
	val = i;
	return self;
}


-(int)value {
	return val;
}

-(int)hash {
	return val;
}

-(BOOL)isEqual:(ChObject *)other {
	ChInteger *o;
	if([other isKindOfClass:[ChInteger class]] == NO) {
		return NO;
	}
	o = (ChInteger *)other;
	return [self value] == [o value];
}

@end

