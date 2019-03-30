%{
    #include<stdio.h>
    #include<stdlib.h>
    #include<string.h>
    int conta = 0;
    char s[50];
    FILE * traducoes;
    void insertTranslation(FILE* f, char* t);
%}

%%
[*].*\n[:]*[-]*[ ]*[']*(?i:("Tradução"|"Tradução literal"))[:]?[^\n]*      {insertTranslation(traducoes,yytext); conta++;}
[*]" &quot;".*\n"**"[ ]?"Tradução:"[^\n]*                                  {insertTranslation(traducoes,yytext); conta++;}
[*][ ]*"&quot;".*\n[*]*"Original"[ ]*[:]?[^\n]*                            {insertTranslation(traducoes,yytext); conta++;}
[*][ ]?.*\n[*]{2}[']{2}"Tradução''"[:][^\n]*                               {insertTranslation(traducoes,yytext); conta++;}
[*][ ]*[']{3}.*\n[*]{2}[ ]*[']{2}"Tradução"[^\n]*                          {insertTranslation(traducoes,yytext); conta++;}
[*]" &quot;".*"&quot;"\n": "[A-Za-z][^\n]*                                 {insertTranslation(traducoes,yytext); conta++;}
[:].*[']{3}.*\n[:]+"Tradução literal"[^\n]*                                {insertTranslation(traducoes,yytext); conta++;}
[*].*\n[:][ ]"&lt;u&gt;"("Tradução"|"Literalmente")[:]"&lt;/u&gt;"[^\n]*   {insertTranslation(traducoes,yytext); conta++;}
(.|\n)                                                                  {;}
%%


int yywrap(){
    return 1;
}

int main(){
    traducoes = fopen("traducoes.html", "w+");
    fprintf(traducoes,"<html><head><meta charset='UTF-8'/>\n </head><body><ul>\n");
    fprintf(traducoes,"<h1 align=\"center\"> Lista de Traduções </h1>\n<hr>");
    yylex();
    sprintf(s,"Número de citações lidas: %i\n",conta);
    fprintf(traducoes,"<h2> %s </h2>\n",s);
    fprintf(traducoes,"</BODY> </HTML>");
    fclose(traducoes);
    return 0;
}

void insertTranslation(FILE* f, char* t){
    fprintf(f,"<p>%s</p>\n",t);
}
