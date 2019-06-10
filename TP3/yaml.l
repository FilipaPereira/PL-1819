%{
    #include "y.tab.h"
    #include<ctype.h>
    
    int flag = 0;
%}

%x PAR
%x CONT
%x OBJ
%x ARR
%x KEYVAL
%x BOOL
%x ARRVAL
%x LIST

%%
[ \t\n]*                        { }
"---"                           { return START; }
^[#][^\n]*                      { }
^[A-Za-z]*":"                   { yylval.str = strdup(yytext); yylval.str[yyleng - 1] = '\0'; flag = 0; return KEY; }
[-]                             { if(flag==0) BEGIN LIST; else BEGIN ARR; }
[a-zA-Z0-9 ]+":"                { printf("%s\n",yytext); flag=1; BEGIN OBJ; yylval.str=strdup(yytext); return OBJECTKEY;}
<OBJ>[\n]                       { BEGIN INITIAL;}
<OBJ>[a-zA-Z0-9][^\n]*          { printf("%s\n",yytext); BEGIN INITIAL; yylval.str=strdup(yytext); return OBJECTVALUE;}
<LIST>[^\n]*                    { yylval.str = strdup(yytext+1); BEGIN INITIAL; return list; }
<ARR>[A-Za-z]*":"               { yylval.str = strdup(yytext); BEGIN ARRVAL; return ARRAYKEY; }
<ARRVAL>[^\n]*                  { BEGIN INITIAL; yylval.str=strdup(yytext); return ARRAYVALUE; }
<AARVAL>[\n]                    { BEGIN INITIAL; yylval.str=strdup("null"); return ARRAYVALUE;  }
[A-Za-z]*": >"                  { yylval.str = strdup(yytext); yylval.str[yyleng - 3] = '\0'; BEGIN PAR; return PARAGRAPH; }
<PAR>[' ']{3}[^\n]*		   	    { yylval.str = strdup(yytext+3); yylval.str[yyleng - 1] = '\0'; return blockline; }
<PAR>[\n]						{ yylval.str = strdup(yytext); yylval.str[yyleng - 1] = '\0';}
<PAR>^([A-Za-z])				{ BEGIN INITIAL; }
[A-Za-z]*": |-"                 { yylval.str = strdup(yytext); yylval.str[yyleng - 4] = '\0'; BEGIN CONT; return CONTENT; }
<CONT>[' ']{3}[^\n]*		   	{ yylval.str = strdup(yytext+3); yylval.str[yyleng - 1] = '\0'; return blockline; }
<CONT>^([A-Za-z])				{ BEGIN INITIAL; }
(.|\n)                		    { ; }
%%

int yywrap(){
    return 1;
}


