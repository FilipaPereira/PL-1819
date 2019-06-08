%{
    #include "y.tab.h"
    #include<ctype.h>
%}


%%
[ \t\n]*                        { }
"---"                          { return START; }
^[#][^\n]*                     { }
[A-Za-z]*":"                    { yylval.str = strdup(yytext); yylval.str[yyleng - 1] = '\0'; return OBJECT; }
","                             { yylval.str = strdup(yytext); return COMMA; }
[-][^\n]*                       { yylval.str = strdup(yytext); return lista; }
[A-Za-z]*": >"                  { return PARAGRAPH; }
[A-Za-z]*": |-"                 { return CONTENT; }
[A-Za-z]*":"[ A-Za-z]+[^\n]*    { yylval.keyvalue = strdup(yytext);
                                  return KEYVALUE;
                                }
(.|\n)                  { ; }
%%

int yywrap(){
    return 1;
}


