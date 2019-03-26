%{
    #include<stdio.h>
    #include<stdlib.h>
    #include<string.h>
    //Percorrer um ficheiro html e listar as tags utilizadas.
    int autores = 0, i=0, quote=0;
    int quotesautor[10000];
    int idautor[10000];
%}

%x AUTOR
%x NOME
%x QUOTE

%%
"{{Autor"                                     {BEGIN AUTOR;}
<AUTOR>^([*][ ]?&quot;)                       {i++; quote++; BEGIN QUOTE;}
<AUTOR>^[ ]*"</page>"                         {autores++;}
<QUOTE>.*&quot;                               {quotesautor[autores] = quote; quote = 0; BEGIN AUTOR;}
(.|\n)                                        {;}
%%


int yywrap(){
    return 1;
}

int main(){
    
    yylex();
    for(int j=0; j<autores; j++) printf("Autor: %i, Numero de quotes: %i",autores,quotesautor[j]);
    printf("Estatísticas:\n Foram encontrados %i autores e %i quotes.\n", autores, i);
    
    return 0;
}




