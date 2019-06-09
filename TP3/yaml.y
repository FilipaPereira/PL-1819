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
%token<str> KEY
%token<str> PARAGRAPH
%token<str> CONTENT
%token<str> COLON
%token<str> COMMA
%token<str> NULLVALUE
%token<str> BOOLEAN
%token<str> BOOLVALUE
%token<str> ARRAY
%token<str> ARRAYKEY
%token<str> ARRAYVALUE
%token<str> list
%token<str> array
%token<str> blockline
%token<keyvalue> KEYVALUE
%type<str> Value KeyValuePair KeyValuePairs Block Array Entry


%%
Programa : START KeyValuePairs {printf("{\n%s\n}\n",$2);}
         ;

KeyValuePairs : KeyValuePair                   {$$=$1;}
              | KeyValuePairs KeyValuePair     {asprintf(&$$, "%s,\n%s",$1,$2);}
              ;

KeyValuePair : KEY Value             {asprintf(&$$, "\"%s\": [\n%s\n]",$1,$2);}
             | PARAGRAPH Block       {asprintf(&$$, "\"%s\": \"%s\\n\",",$1,$2);}
             | CONTENT Block         {asprintf(&$$, "\"%s\": \"%s\\n\",",$1,$2);}
             | OBJECT Value          {asprintf(&$$, "\"%s\": {\n  %s\n}",$1,$2);}
             ;

Value :
    | list                          {asprintf(&$$, "  \"%s\"",$1);}
    | Value list                    {asprintf(&$$, "%s\n  \"%s\"",$1,$2);}
    | KEYVALUE                      { char* tokens = strtok ($1,": ");
                                      char* values[2];
                                      values[0] = strdup(tokens);
                                      tokens = strtok (NULL, ": ");
                                      values[1] = strdup(tokens);
                                      asprintf(&$$, "\"%s\": \"%s\"",values[0],values[1]);}
    | ARRAY Array                   {asprintf(&$$, "\"%s\": [\n%s\n]",$1,$2);}
    | KeyValuePairs                 {asprintf(&$$, "%s",$1);}
    ;

Block : blockline					{asprintf(&$$, "%s",$1);}
      | Block blockline				{asprintf(&$$, "%s\\n%s",$1,$2);}
      ;

Array : Entry                       {asprintf(&$$, "{\n  %s\n}",$1);}
      | Array Entry                 {asprintf(&$$, "%s,%s",$1,$2);}
      ;

Entry : NULLVALUE                   {asprintf(&$$, "\"%s\": null",$1);}
      | BOOLEAN BOOLVALUE           {asprintf(&$$, "\"%s\": %s",$1,$2);}
      | ARRAYKEY ARRAYVALUE         {asprintf(&$$, "\"%s\": %s",$1,$2);}
      ;

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
