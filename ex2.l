%{
    #include<stdio.h>
    #include<stdlib.h>
    #include<string.h>
    char* nome="";
    int conta1 = 0, conta2 = 0;
%}

%x TRAD1
%x TRAD2

%%
[*]+[ ]*"''&quot;"[^\n]*                                    {BEGIN TRAD2; printf("Tipo 2: %s\n",yytext);}
[*]+[ ]"&quot;"[^\n]*                                       {BEGIN TRAD1;printf("Tipo 1a: %s\n",yytext);}
"* "[^.]*([:]*[-]?[ ]*("Tradução:"|"Tradução Literal:"))    {BEGIN TRAD1; printf("Tipo 1: %s\n",yytext);}
<TRAD1>^([:][-]+[ ]?)[^\n]*									                {;}
<TRAD2>^([*]*[:]?\ *("Tradução:"|"Tradução Literal:"))      {printf("Tipo 2: %s\n",yytext);}
<TRAD1>^([:]*[-]?[ ]*("Tradução:"|"Tradução Literal:"))     {printf("Tipo 1: %s\n",yytext);}
<TRAD2>[^\n]*                                               {printf("2----\n%s\n----\n",yytext); conta2++;BEGIN INITIAL;}
<TRAD1>[^\n]*                                               {printf("1----\n%s\n----\n",yytext);conta1++; BEGIN INITIAL;}
<TRAD2>(.|\n)                                               {;}
<TRAD1>(.|\n)                                               {;}
(.|\n)                                                      {;}
%%


int yywrap(){
    return 1;
}

int main(){

    printf("Início da filtragem\n");
    yylex();
    printf("Fim da filtragem\n");
    printf("Tipo 1: %d\n", conta1);
    printf("Tipo 2: %d\n", conta2);

    return 0;
}
