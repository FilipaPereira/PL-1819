%{
    #include "y.tab.h"
    #include<ctype.h>
    
    int flag = 0;
%}

%x PAR
%x CONT
%x OBJ
%x ARR
%x ARRVAL
%x LIST

%%
[ \t\n]*                        { ; }
"---"                           { return START; }
^[#][^\n]*                      { }
^[A-Za-z]*":"                   { yylval.key = strdup(yytext); yylval.key[yyleng - 1] = '\0'; flag = 0; return KEY; }
[-]                             { if(flag==0) BEGIN LIST; else BEGIN ARR; }
[a-zA-Z0-9 ]+":"                { flag=1; BEGIN OBJ; yylval.str=strdup(yytext); return OBJECTKEY;}
<OBJ>[\n]                       { BEGIN INITIAL;}
<OBJ>[a-zA-Z0-9][^\n]*          { BEGIN INITIAL; yylval.str=strdup(yytext); return OBJECTVALUE;}
<LIST>[^\n]*                    { yylval.str = strdup(yytext+1); BEGIN INITIAL; return list; }
<ARR>[A-Za-z\_\-\ ]*":"         { yylval.key = strdup(yytext); BEGIN ARRVAL; return ARRAYKEY; }
<ARRVAL>[^\n]*                  { BEGIN INITIAL; yylval.arrayvalue=strdup(yytext+1); return ARRAYVALUE; }
<ARRVAL>[\n]                    { BEGIN INITIAL; yylval.arrayvalue=strdup("null"); return ARRAYVALUE;  }
[A-Za-z]*": >"                  { yylval.str = strdup(yytext); yylval.str[yyleng - 3] = '\0'; BEGIN PAR; return PARAGRAPH; }
<PAR>[ ]{3}[^\n]*               { yylval.str = strdup(yytext+3); yylval.str[yyleng - 1] = '\0'; return blockline; }
<PAR>^([\n])                    { yylval.str = strdup("\\n"); return blockline;}
<PAR>[\n]/([A-Za-z])            { BEGIN INITIAL; yylval.str = strdup("\\n"); return blockline;}
[A-Za-z]*": |-"                 { yylval.str = strdup(yytext); yylval.str[yyleng - 4] = '\0'; BEGIN CONT; return CONTENT; }
<CONT>[ ]{3}[^\n]*              { yylval.str = strdup(yytext+3); yylval.str[yyleng - 1] = '\0'; return contLine; }
<CONT>[\n]/([A-Za-z])           { BEGIN INITIAL;}
(.|\n)                		    { ; }
%%

int yywrap(){
    return 1;
}


