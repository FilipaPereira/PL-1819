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
%token<str> OBJECTKEY
%token<str> OBJECTVALUE
%token<str> ARRAYKEY
%token<str> ARRAYVALUE
%token<str> list
%token<str> array
%token<str> blockline
%token<keyvalue> KEYVALUE
%type<str> KeyValuePair KeyValuePairs Block Array List KeyValue Object


%%
Programa : START KeyValuePairs       {printf("{\n%s\n}\n",$2);}
         ;

KeyValuePairs : KeyValuePair                    {$$=$1;}
              | KeyValuePairs KeyValuePair      {asprintf(&$$, "%s,\n%s",$1,$2);}
              ;

KeyValuePair : KEY List                         {asprintf(&$$, "\"%s\": [\n%s\n]",$1,$2);}
             | KEY Object                       {asprintf(&$$, "\"%s\": \"%s\"",$1,$2);}
             | PARAGRAPH Block                  {asprintf(&$$, "\"%s\": \"%s\\n\",",$1,$2);}
             | CONTENT Block                    {asprintf(&$$, "\"%s\": \"%s\\n\",",$1,$2);}
             ;

Object : KeyValue                               {asprintf(&$$, "%s",$1);}
        | Object KeyValue                       {asprintf(&$$, "%s\n%s",$1,$2);}
        ;

KeyValue : OBJECTKEY Array                      {asprintf(&$$, "%s\n%s",$1,$2);}
        | OBJECTKEY OBJECTVALUE                 {asprintf(&$$, "%s\n%s",$1,$2);}
        ;

Array : ARRAYKEY ARRAYVALUE                     {asprintf(&$$, "{--\n%s %s\n}",$1,$2);}
    | Array ARRAYKEY ARRAYVALUE                 {asprintf(&$$, "%s,%s%s",$1,$2,$3);}
    ;


List : list                                     {asprintf(&$$, "  \"%s\"",$1);}
    | List list                                 {asprintf(&$$, "%s\n  \"%s\"",$1,$2);}
    ;

Block : blockline           					{asprintf(&$$, "%s",$1);}
      | Block blockline	            			{asprintf(&$$, "%s\\n%s",$1,$2);}
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
