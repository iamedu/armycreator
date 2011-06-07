#ifndef _CHILES_CHINTEGER_H
#define _CHILES_CHINTEGER_H

#import <Chiles/ChObject.h>
#import <Chiles/Hashable.h>

@interface ChInteger : ChObject<Hashable> {
	int val;
}

-(id)initFromInt:(int)i;
-(int)value;

@end

#endif

