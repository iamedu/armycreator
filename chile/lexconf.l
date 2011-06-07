%{
#include <string.h>
#include "conf.h"
%}

LETTER	[/a-zA-Z0-9\.]

%%

"["{LETTER}+"]"	{
			int i;
			int len;

			len = strlen(yytext);

			char *section = malloc(strlen(yytext) - 1);
			//yylval.value = malloc(strlen(yytext));

			//strcpy(yylval.value, yytext);

			for(i = 1; i < len - 1; i++) {
				section[i - 1] = yytext[i];
			}
			section[i - 1] = '\0';

			yylval.value = section;

			return SECTION;
		}
({LETTER}|,)+	{
			yylval.value = malloc(strlen(yytext) + 1);
			strcpy(yylval.value, yytext);
			return VALUE;
		}
"="		{ return EQ; }
[ \t\n]+	

%%

/*
int main() {
	yylex();
	return 0;
}
*/

