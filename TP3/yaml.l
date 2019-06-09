%{
    #include "y.tab.h"
    #include<ctype.h>
%}

%x PAR
%x CONT

%%
[ \t\n]*                        { }
"---"                           { return START; }
^[#][^\n]*                      { }
[A-Za-z]*":"                    { yylval.str = strdup(yytext); yylval.str[yyleng - 1] = '\0'; return OBJECT; }
","                             { yylval.str = strdup(yytext); return COMMA; }
[-][^\n]*                       { yylval.str = strdup(yytext); return lista; }
[A-Za-z]*": >"                  { yylval.str = strdup(yytext); yylval.str[yyleng - 3] = '\0'; BEGIN PAR; return PARAGRAPH; }
<PAR>[' ']{3}[^\n]*		   	    { yylval.str = strdup(yytext+3); yylval.str[yyleng - 1] = '\0'; return blockline; }
<PAR>[\n]						{ yylval.str = strdup(yytext); yylval.str[yyleng - 1] = '\0';}
<PAR>^([A-Za-z])				{ BEGIN INITIAL;}
[A-Za-z]*": |-"                 { yylval.str = strdup(yytext); yylval.str[yyleng - 4] = '\0'; BEGIN CONT; return CONTENT; }
<CONT>[' ']{3}[^\n]*		   	{ yylval.str = strdup(yytext+3); yylval.str[yyleng - 1] = '\0'; return blockline; }
<CONT>^([A-Za-z])				{ BEGIN INITIAL;}
[A-Za-z]*":"[ A-Za-z]+[^\n]*    { yylval.keyvalue = strdup(yytext); return KEYVALUE;}
(.|\n)                		    { ; }
%%

int yywrap(){
    return 1;
}


