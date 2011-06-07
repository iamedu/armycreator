#import <Chiles/ChConf.h>
#import <Chiles/Utils.h>
#import <stdio.h>
#import <stdlib.h>

extern FILE *yyin;
int yyparse(void *);

@implementation ChConf


-(id)initWithFilename:(ChString *)f {
	struct parser_result r;
	yyin = fopen([f cString], "r");
	if(yyin == NULL) {
		sections = [[ChDictionary alloc] init];
		return self;
	}
	yyparse(&r);
	fclose(yyin);
	sections = r.dict;

	return self;
}

-(ChString *)get:(ChString *)key at:(ChString *)section {
	ChDictionary *dict;

	dict = (ChDictionary *)[sections get:section];

	if(dict == (ChDictionary *)Nil)
		return (ChString *)Nil;

	return (ChString *)[dict get:key];
}

-(ChList *)sectionNames {
	return [sections keys];
}

-(ChDictionary *)sections {
	return sections;
}


@end

