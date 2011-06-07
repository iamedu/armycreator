#import <Chiles/ChString.h>

@implementation ChConstantString

-(const char *) cString {
	return c_string;
}

-(unsigned int)length {
	return len;
}

@end

