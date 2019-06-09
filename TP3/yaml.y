%{
    #include <string.h>
    #include <stdio.h>
    #include<stdlib.h>
    #define _GNU_SOURCE
    int yylex(void);
    int yyerror(char* s);
%}

%union {char* str; char* keyvalue;}

%token<str> START
%token<str> JSON
%token<str> YAML
%token<str> OBJECT
%token<str> PARAGRAPH
%token<str> CONTENT
%token<str> COLON
%token<str> COMMA
%token<str> lista
%token<str> blockline
%token<keyvalue> KEYVALUE
%type<str> Value KeyValuePair KeyValuePairs Block


%%
Programa : START KeyValuePairs {printf("{ \n%s\n}\n",$2);}
         ;

KeyValuePairs : KeyValuePair                   {$$=$1;}
              | KeyValuePairs KeyValuePair     {asprintf(&$$, "%s\n%s",$1,$2);}
              ;

KeyValuePair : OBJECT Value          {asprintf(&$$, "\"%s\": [\n%s\n],",$1,$2);}
             | PARAGRAPH Block       {asprintf(&$$, "\"%s\": \"%s\\n\",",$1,$2);}
             | CONTENT Block         {asprintf(&$$, "\"%s\": \"%s\\n\",",$1,$2);}
             ;

Value :
    | lista                         {asprintf(&$$, "%s",$1);}
    | Value lista                   {asprintf(&$$, "%s\n%s",$1,$2);}
    | KEYVALUE                      { char* tokens = strtok ($1,": ");
                                      char* values[2];
                                      values[0] = strdup(tokens);
                                      printf ("HELLO %s\n",values[0]);
                                      tokens = strtok (NULL, ": ");
                                      values[1] = strdup(tokens);
                                      printf ("HELLO %s\n",values[1]);
                                      asprintf(&$$, "\"%s\": \"%s\"",values[0],values[1]);}
    | KeyValuePairs                 {asprintf(&$$, "%s",$1);}
    ;

Block : blockline					{asprintf(&$$, "%s",$1);}
      | Block blockline				{asprintf(&$$, "%s\\n%s",$1,$2);}

%%

#include "lex.yy.c"

int yyerror(char *s) {
    printf("Erro: %s \n",s );
    return 1;
}

int main(){
    yyparse();
    return 0;
}
