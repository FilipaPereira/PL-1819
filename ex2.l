%{
    #include<stdio.h>
    #include<stdlib.h>
    #include<string.h>
    int conta = 0;
    %}

%x TRAD
%x QUOTE
%x TRAD2

%%
\*.*\n[:]*[-]*[ ]*[']*(?i:("Tradução"|"Tradução literal"))[:]?[^\n]*  {printf("Encontrei uma tradução de tipo 1:\n%s\n\n",yytext); conta++;}
\*" &quot;".*\n"**"[ ]?"Tradução:"[^\n]*                              {printf("Encontrei uma tradução de tipo 2:\n%s\n\n",yytext); conta++;}
\*[ ]*"&quot;".*\n[*]*"Original"[ ]*[:]?[^\n]*                        {printf("Encontrei uma tradução de tipo 3:\n%s\n\n",yytext); conta++;}
\*"* &quot".*\n"** &quot;"[^\n]*                                      {printf("Encontrei uma tradução de tipo 4:\n%s\n\n",yytext); conta++;}
\*[ ]*[']{3}.*\n[*]{2}[ ]*[']{2}"Tradução"[^\n]*                      {printf("Encontrei uma tradução de tipo 5:\n%s\n\n",yytext); conta++;}
\*" &quot;".*"&quot;"\n": "[A-Za-z][^\n]*                             {printf("Encontrei uma tradução de tipo 6:\n%s\n\n",yytext); conta++;}
<*>(.|\n)                                                             {;}
%%


int yywrap(){
    return 1;
}

int main(){
    
    yylex();
    printf("Consegui ler %i traduções.\n",conta);
    return 0;
}
