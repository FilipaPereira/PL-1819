%{
    #include<stdio.h>
    #include<stdlib.h>
    #include<string.h>
    char* nome="";
    int len=0,len2=0;
%}

%x AUTOR
%x NOME
%x QUOTE1
%x QUOTE2

%%
"{{Autor"                                     {BEGIN AUTOR;}
<AUTOR>"|"[ ]*("Nome"|"Nombre")[ ]*"="[ ]*    {BEGIN NOME;}
<AUTOR>(.|\n)                                 {;}
<NOME>[^\n]*                                  {nome = strdup(yytext); printf("--------\nAUTOR: %s \n",nome); BEGIN INITIAL;}
^([*]&quot;)                                  {len = yyleng; BEGIN QUOTE1;}
^([*][ ]&quot;)                               {len2 = yyleng; BEGIN QUOTE2;}
<QUOTE1>.*&quot;[.]?[ ]?                      {yytext[yyleng-len+1]='\0';printf("%s\n",yytext);BEGIN INITIAL;}
<QUOTE2>.*&quot;[.]?[ ]?                      {yytext[yyleng-len2+2]='\0';printf("%s\n",yytext);BEGIN INITIAL;}
<QUOTE1>[^\n]*                                {printf("%s\n",yytext);BEGIN INITIAL;}
<QUOTE2>[^\n]*                                {printf("%s\n",yytext);BEGIN INITIAL;}
(.|\n)                                        {;}
%%


int yywrap(){
    return 1;
}

int main(){

    printf("Início da filtragem\n");
    yylex();
    printf("Fim da filtragem\n");

    return 0;
}
