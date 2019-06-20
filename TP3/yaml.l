%{
    #include "y.tab.h"
    #include<ctype.h>
    int flag = 0;
%}
%option noyywrap

%x PAR
%x CONT
%x OBJ
%x ARR
%x ARRVAL
%x LIST

%%
---                             { return START; }
^#[^\n]*\n                       { ; }
^[A-Za-z]*":"                   { yylval.key = strdup(yytext); yylval.key[yyleng - 1] = '\0'; flag = 0; return KEY; }
^[A-Za-z]*":"[^\n]*             { yylval.key = strdup(yytext); return KEYVALUE; }
[-]                             { if(flag==0) BEGIN LIST; else BEGIN ARR; }
[a-zA-Z0-9]+":"                 { flag=1; BEGIN OBJ; yylval.str=strdup(yytext); yylval.str[yyleng - 1] = '\0'; return OBJECTKEY; }
<OBJ>[\n]                       { BEGIN INITIAL;}
<OBJ>[a-zA-Z0-9][^\n]*          { BEGIN INITIAL; yylval.str=strdup(yytext); return OBJECTVALUE; }
<LIST>[^\n]*                    { yylval.str = strdup(yytext+1); BEGIN INITIAL; return list; }
<ARR>[^\n]*":"                  { yylval.key = strdup(yytext+1); yylval.key[yyleng - 2] = '\0'; BEGIN ARRVAL; return ARRAYKEY; }
<ARRVAL>[^\n]*                  { BEGIN INITIAL; yylval.arrayvalue=strdup(yytext+1); return ARRAYVALUE; }
<ARRVAL>[\n]                    { BEGIN INITIAL; yylval.arrayvalue=strdup("null"); return ARRAYVALUE;  }
[A-Za-z]*": >"/([\n])           { yylval.str = strdup(yytext); yylval.str[yyleng - 3] = '\0'; BEGIN PAR; return PARAGRAPH; }
<PAR>[ ]{3}[^\n]*               { yylval.str = strdup(yytext+3); yylval.str[yyleng - 1] = '\0'; return blockline; }
<PAR>^([\n])                    { yylval.str = strdup("\\n"); return blockline;}
<PAR>[\n]/([A-Za-z])            { BEGIN INITIAL; yylval.str = strdup("\\n"); return blockline;}
[A-Za-z]*": |-"/([\n])          { yylval.str = strdup(yytext); yylval.str[yyleng - 4] = '\0'; BEGIN CONT; return CONTENT; }
[A-Za-z]*": |"/([\n])           { yylval.str = strdup(yytext); yylval.str[yyleng - 3] = '\0'; BEGIN CONT; return CONTENT; }
<CONT>[ ]{3}[^\n]*              { yylval.str = strdup(yytext+3); yylval.str[yyleng - 1] = '\0'; return contLine; }
<CONT>[\n]/([A-Za-z])           { BEGIN INITIAL; }
<*>(.|\n)                		    { ; }
%%


