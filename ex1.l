%{
    #include<stdio.h>
    #include<stdlib.h>
    #include<string.h>
    FILE * file;
    char* nome="";
%}

%x AUTOR
%x NOME
%x QUOTE
%x PAGE
%x TEXT

%%
^([ ]*"<page>")                               {nome=""; BEGIN PAGE;}
<PAGE>"<text".*"{{Autor"                      {BEGIN AUTOR;}
<AUTOR>"|"[ ]*("Wikipedia")[ ]*"="[ ]*        {BEGIN NOME;}
<NOME>[^("|"|\n)]*                            {nome = strdup(yytext); printf("--------\nAUTOR: %s \n",nome); BEGIN INITIAL;}
^([*][ ]*"&quot;")                            {BEGIN QUOTE;}
<QUOTE>[^\n]*                                 {fprintf(file, "<p><b>%s</b>",nome);fprintf(file, " %s</p>\n",yytext);("%s\t QUOTE1\n",yytext); BEGIN INITIAL;}
<AUTOR>^("[[Categoria")                       {BEGIN PAGE;}
<PAGE>^([*][ ]*"&quot;")                      {BEGIN QUOTE;}
<*>(.|\n)                                     {;}
%%


int yywrap(){
    return 1;
}

int main(){
    file = fopen("quotes.html","w");
    fprintf(file, "<HTML> <BODY> <meta charset='UTF-8'/>");
    yylex();
    fprintf(file,"</BODY> </HTML>");
    fclose(file);

    return 0;
}
