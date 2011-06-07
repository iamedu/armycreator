#import <Chiles/ChString.h>
#import <Chiles/ChList.h>
#import <string.h>

@implementation ChString

-(const char *) cString {
	return (const char *)nil;
}

-(unsigned int)length {
	return 0;
}

-(ChString *)description {
	return self;
}

-(ChString *)concat:(ChString *)other {
	ChInmutableString *str;
	char *cstr;
	int size;
	int i;
	int ii;

	size = [self length] + [other length] + 1;
	cstr = (char *)malloc(size);

	for(i = 0; i < [self length]; i++) {
		cstr[i] = [self cString][i];
	}

	for(ii = 0; ii < [other length]; ii++, i++) {
		cstr[i] = [other cString][ii];
	}

	cstr[i] = '\0';


	str = [[ChInmutableString alloc] initWithCString:cstr];

	return str;
}

-(int)hash {
	//Taken from openjdk 1.6
	int h = 0;
	int i;
	int len;
	char *cstr;
	cstr = (char *)[self cString];
	len  = [self length];
	for(i = 0; i < len; i++) {
		h = 31 * h + cstr[i];
	}
	return h;
}

+(ChString *)valueOf:(int)d {
	ChString *str;
	char *cstr = malloc(11);
	sprintf(cstr, "%d", d);

	str = [[ChInmutableString alloc] initWithCString:cstr];
	
	return str;
}

-(int)toInt {
	int i;
	int result = 0;
	unsigned int tmp;
	int off = 0;
	int base = 10;
	int l   = [self length];
	char *c = (char *)[self cString];

	if(l > 2) {
		if(c[0] == '0' && c[1] == 'x') {
			base = 16;
			off = 2;
		}
	}

	for(i = off; i < l; i++) {
		result *= base;
		tmp = tolower(c[i]);
		if(tmp >= 'a') {
			tmp -= 'a';
			tmp += 10;
		} else {
			tmp -= '0';
		}
		result += tmp;
	}


	return result;
}

-(ChArray *)split:(ChString *)delim {
	ChList *l;
	ChString *str;
	ChArray *result;
	char *saveptr;
	char *cstr;
	char *tmp;
	char *res;
	char *ctoken;


	cstr = (char *)[self cString];
	ctoken = (char *)[delim cString];
	l = [[ChList alloc] init];

	res = strtok_r(cstr, ctoken, &saveptr);

	while(res != NULL) {
		tmp = malloc(strlen(res) + 1);
		strcpy(tmp, res);
		str = [[ChInmutableString alloc] initWithCString:tmp];
		[l insert:str];
		res = strtok_r(NULL, ctoken, &saveptr);
	}

	result = [l toArray];

	[l release];

	return result;
}

-(BOOL)isEqual:(ChObject *)other {
	ChString *o;
	if([other isKindOfClass:[ChString class]] == NO) {
		return NO;
	}
	o = (ChString *)other;
	return strcmp([self cString], [o cString]) == 0;
}

@end

@implementation ChInmutableString

-(id)initWithCString:(char *)cstr {
	c_string = cstr;
	len = strlen(cstr);
	return self;
}

-(const char *) cString {
	return c_string;
}

-(unsigned int)length {
	return len;
}

@end

