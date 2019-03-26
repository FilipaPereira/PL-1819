%{
    #include<stdio.h>
    #include<stdlib.h>
    #include<string.h>
    #include <glib.h>
    #include <ctype.h>
    GHashTable* hash;
    FILE * file;
    char* nome="";
    int len=0,len2=0;
    
    gboolean printAutor(gpointer key, gpointer value, gpointer data);
    void insertAutor(char * autor);
    void table();
%}

%x AUTOR
%x NOME
%x QUOTE
%x PAGE
%x TEXT

%%
^([ ]*"<page>")                              {nome=""; BEGIN PAGE;}
<PAGE>"<text".*"{{Autor"                      {BEGIN AUTOR; len++;}
<AUTOR>"|"[ ]*("Wikipedia")[ ]*"="[ ]*    {BEGIN NOME;}
<NOME>[^("|"|\n)]*                                  {nome = strdup(yytext); printf("--------\nAUTOR: %s \n",nome); BEGIN INITIAL;}
^([*][ ]*"&quot;")                            {insertAutor(nome); BEGIN QUOTE;}
<QUOTE>[^\n]*                            {yytext[yyleng-6]='\0'; printf("%s\t QUOTE1\n",yytext); BEGIN INITIAL;}
<*>(.|\n)                                        {;}
%%


int yywrap(){
    return 1;
}

int main(){
    
    hash = g_hash_table_new(g_str_hash, g_str_equal);
    file = fopen("html/estatisticas.html","w+");
    
    yylex();
    fprintf(file, "<HTML> <BODY> <meta charset='UTF-8'/>");

    table();
    g_hash_table_foreach(hash, printAutor, NULL);

    fprintf(file, "</table>");

    fprintf(file,"</BODY> </HTML>");
    printf("\n------SIZE---\n %i\nlen %i\n",g_hash_table_size(hash),len);
    fclose(file);
    
    return 0;
}

void table(){
    fprintf(file, "<style>table, th, td { border: 1px solid black;} </style>");
    fprintf(file, "<table>");
    fprintf(file, "<tr>");
    fprintf(file, "<th>Autor</th>");
    fprintf(file, "<th>Numero de Citações</th>");
    fprintf(file, "</tr>");
}

gboolean printAutor(gpointer key, gpointer value, gpointer data){
    fprintf(file, "<tr>");
    fprintf(file, "<td>%s</td>\n",key);
    fprintf(file, "<td>%d</td>",*((int *)value));
    fprintf(file, "</tr>");
    return FALSE;
}

void insertAutor(char * autor){
    gpointer value = g_hash_table_lookup(hash,autor);
    int * n;
    if (value == NULL){
        n = (int *) malloc(sizeof(int));
        *n = 1;
        g_hash_table_insert(hash,(gpointer)autor,(gpointer)n);
    }
    else{
        n = (int *) value;
        int m = *n;
        m++;
        (*n) = m;
    }
}
