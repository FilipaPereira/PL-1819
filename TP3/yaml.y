%{
    #include <string.h>
    #include <stdio.h>
    #include<stdlib.h>
    #define _GNU_SOURCE
    int yylex(void);
    int yyerror(char* s);
%}
%union {char* str; char* key; char* arrayvalue;}

%token START
%token<key> KEY
%token<key> KEYVALUE
%token<str> PARAGRAPH
%token<str> CONTENT
%token<str> OBJECTKEY
%token<str> OBJECTVALUE
%token<key> ARRAYKEY
%token<arrayvalue> ARRAYVALUE
%token<str> list
%token<str> blockline
%token<str> contLine
%type<str> KeyValuePair KeyValuePairs Block Array List KeyValue Object contBlock


%%
Programa : START KeyValuePairs       {FILE* file = fopen("Y2J.json","w+"); fprintf(file,"{\n%s\n}\n",$2);}
         ;

KeyValuePairs : KeyValuePair                    {asprintf(&$$, "  %s",$1);}
              | KeyValuePairs KeyValuePair      {asprintf(&$$, "%s,\n  %s",$1,$2);}
              ;

KeyValuePair : KEY List                         {asprintf(&$$, "\"%s\": [\n    %s\n  ]",$1,$2);}
            | KEY Object                       {asprintf(&$$, "\"%s\":{\n  %s\n  }",$1,$2);}
            | PARAGRAPH Block                  {asprintf(&$$, "\"%s\": \"%s\"",$1,$2);}
            | CONTENT contBlock                {asprintf(&$$, "\"%s\": \"%s\"",$1,$2);}
            | KEYVALUE                         {char* tokens = strtok ($1,": ");
                                                char* values[2];
                                                values[0] = strdup(tokens);
                                                tokens = strtok (NULL, ": ");
                                                values[1] = strdup(tokens);
                                                asprintf(&$$, "\"%s\": \"%s\"",values[0],values[1]);}
            ;

Object : KeyValue                               {asprintf(&$$, "  %s",$1);}
        | Object KeyValue                       {asprintf(&$$, "%s,\n  %s",$1,$2);}
        ;

KeyValue : OBJECTKEY Array                      {asprintf(&$$, "  \"%s\": [\n%s\n    ]",$1,$2);}
        | OBJECTKEY OBJECTVALUE                 {asprintf(&$$, "\"%s\": \"%s\"",$1,$2);}
                ;

Array : ARRAYKEY ARRAYVALUE                 {asprintf(&$$, "     {\n    \"%s\": %s\n     }",$1,$2);}
        | Array ARRAYKEY ARRAYVALUE                 {asprintf(&$$, "%s,\n     {\n    \"%s\": %s\n     }",$1,$2,$3);}
        ;


List : list                                     {asprintf(&$$, "\"%s\"",$1);}
    | List list                                 {asprintf(&$$, "%s\n    \"%s\"",$1,$2);}
    ;

Block : blockline                                 {asprintf(&$$, "%s",$1);}
        | Block blockline                         {asprintf(&$$, "%s%s",$1,$2);}
        ;

contBlock : contLine                              {asprintf(&$$, "%s",$1);}
            | contBlock contLine                  {asprintf(&$$, "%s\\n%s",$1,$2);}
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
