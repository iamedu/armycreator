#ifndef _CHSTRING_H
#define _CHSTRING_H

#import <Chiles/ChTypes.h>
#import <Chiles/ChObject.h>
#import <Chiles/ChArray.h>
#import <Chiles/Hashable.h>

@interface ChString : ChObject <Hashable> {
}

-(const char*) cString;
-(UWord) length;
-(ChString *)concat:(ChString *)other;
+(ChString *)valueOf:(int)d;
-(int)toInt;
-(ChArray *)split:(ChString *)delim;

@end

@interface ChInmutableString : ChString {
	char *c_string;
	unsigned int len;
}

-(id)initWithCString:(char *)cstr;

@end

@interface ChConstantString : ChString {
	char *c_string;
	unsigned int len;
}

@end

#endif

