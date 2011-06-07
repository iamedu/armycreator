#ifndef _CHILES_CHCONF_H
#define _CHILES_CHCONF_H

#import <Chiles/ChObject.h>
#import <Chiles/ChString.h>
#import <Chiles/ChDictionary.h>

struct parser_result {
	ChDictionary *dict;
};

@interface ChConf : ChObject {
	ChDictionary *sections;
}

-(id)initWithFilename:(ChString *)f;
-(ChString *)get:(ChString *)key at:(ChString *)section;
-(ChList *)sectionNames;
-(ChDictionary *)sections;

@end

#endif

