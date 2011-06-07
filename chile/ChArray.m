#import <Chiles/ChArray.h>

@implementation ChArray 

-(id)initWithLength:(int)length {
	len = length;
	arr = (ChObject **)malloc(sizeof(ChObject *) * len);
}

-(ChObject *)get:(int)index {
	if(index >= len)
		return (ChObject *)Nil;
	return arr[index];
}

-(void)set:(ChObject *)value at:(int)index {
	arr[index] = value;
	[value retain];
}

-(int)length {
	return len;
}

@end

