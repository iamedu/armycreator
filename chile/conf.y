%{
#include <Chiles/ChDictionary.h>
#include <Chiles/ChString.h>
#include <Chiles/ChConf.h>
#include <stdio.h>
#include <stdlib.h>

#define YYPARSE_PARAM param

void yyerror(char *msg);

%}
%union {
	char *value;
}

%start ROOT

%token EQ
%token <value> SECTION
%token <value> VALUE

%type <value> sections
%type <value> section
%type <value> values
%type <value> value
%type ROOT

%%

ROOT:
    sections	{
    			struct parser_result *r;
			r = (struct parser_result *)param;
			r->dict = (ChDictionary *)$1;
    		}
;

sections:
    sections section {
    			ChDictionary *dict1;
			ChDictionary *dict2;
			dict1 = (ChDictionary *)$1;
			dict2 = (ChDictionary *)$2;
			[dict1 merge:dict2];
			$$ = (void *)dict1;
    		     }
|   section
;

section:
    SECTION values {
    			ChDictionary *dict1;
    			ChDictionary *dict2;
			ChString *s;
			s = [[ChInmutableString alloc] initWithCString:$1];
			dict1 = [[ChDictionary alloc] init];
			dict2 = (ChDictionary *)$2;
			[dict1 put:dict2 at:s];
			$$ = (void *)dict1;
    		   }
;

values:
    values value {
    			ChDictionary *dict1;
    			ChDictionary *dict2;
			dict1 = (ChDictionary *)$1;
			dict2 = (ChDictionary *)$2;
			[dict1 merge:dict2];
			$$ = (void *)dict1;
    		 }
|   value
;

value:
    VALUE EQ VALUE {
			ChDictionary *dict;
			ChString *s1;
			ChString *s2;
			dict = [[ChDictionary alloc] init];
			s1 = [[ChInmutableString alloc] initWithCString:$1];
			s2 = [[ChInmutableString alloc] initWithCString:$3];
			[dict put:s2 at:s1];
			$$ = (void *)dict;
                   }
;

%%


void yyerror(char *msg) {
	printf("%s\n", msg);
	abort();
}

/*
int main() {
	yyparse();
	return 0;
}
*/

