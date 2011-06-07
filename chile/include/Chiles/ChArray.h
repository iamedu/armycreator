#ifndef _CHILES_CHARRAY_H
#define _CHILES_CHARRAY_H

#import <Chiles/ChObject.h>

@interface ChArray : ChObject {
	ChObject **arr;
	int len;
}

-(id)initWithLength:(int)length;
-(ChObject *)get:(int)index;
-(void)set:(ChObject *)value at:(int)index;
-(int)length;

@end

#endif

