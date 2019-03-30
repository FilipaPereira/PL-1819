%{
    #include<stdio.h>
    #include<stdlib.h>
    #include<string.h>
    #include <glib.h>
    #include <ctype.h>
    GHashTable* hash;
    FILE * file;
    FILE* indice;
    FILE* autores;
    FILE* page;
    char* nome="", *auxnome="";
    int conta = 0, ncits = 0, len=0, c=0;
    char filename[10*1024], r[10*1024], s[10*1024];
    char * filelink;
    void insertTranslation(FILE* f, char* t);
    gboolean printAutor(gpointer key, gpointer value, gpointer data);
    void insertAutor(char * autor);
    void insertQuote(FILE* f, char* quote);
    void tabelaAutor();
    void removeSpaces(char *str);
    int contaLinhas(char* filename);
%}

%x AUTOR
%x NOME
%x QUOTE
%x PAGE

%%
^([ ]*"<page>")                                                             { fclose(page); nome=""; BEGIN PAGE; }
<PAGE>"<text".*"{{Autor"                                                    { BEGIN AUTOR; len++; }
<AUTOR>"|"[ ]*("Wikipedia")[ ]*"="[ ]*                                      { BEGIN NOME; }
<NOME>[^("|"|\n)]*                                                          { nome = strdup(yytext); auxnome = strdup(nome); removeSpaces(auxnome); 
                                                                                sprintf(filename,"autores/%s.html",auxnome); 
                                                                                page = fopen(filename, "w+");
                                                                                fprintf(page,"<html><head><meta charset='UTF-8'/>\n </head><body><ul>\n"); 
                                                                                fprintf(page,"<h1 align=\"center\"> %s </h1>\n<hr>", nome);
                                                                                BEGIN INITIAL; }
^([*][ ]*"&quot;")                                                          { if(nome) insertAutor(nome); BEGIN QUOTE; }
<QUOTE>[^\n]*                                                               { if(page) insertQuote(page,yytext); ncits++; BEGIN INITIAL; }
<AUTOR>^("[[Categoria")                                                     { BEGIN PAGE; }
<PAGE>^([*][ ]*"&quot;")                                                    { BEGIN QUOTE; }
<*>(.|\n)                                                                   { ; }
%%


int yywrap(){
    return 1;
}


int main(){
    indice = fopen("indice.html","w+");
    autores = fopen("autores.html", "w+");
    

    hash = g_hash_table_new(g_str_hash, g_str_equal);
    
    yylex();
    fprintf(indice,"%s","<html> <head> <meta charset='UTF-8'/>  <style> table, th, td { border: 1px solid black; border-collapse: collapse; } th, td { padding: 5px; } th { text-align: left; } </style> </head> <body>");
    fprintf(indice,"<h1 align=\"center\"> Wiki Quotes </h1>\n<hr>");
    fprintf(indice,"<li> <a href='%s'> %s </a></li>\n","autores.html","Estatísticas de Autores");
    fprintf(indice,"<li> <a href='%s'> %s </a></li>\n","quotes.html","Lista de Citações");
    fprintf(indice,"<li> <a href='%s'> %s </a></li>\n","traducoes.html","Lista de Traducoes");
    fprintf(autores, "<HTML> <BODY> <meta charset='UTF-8'/>");
    fprintf(autores,"<h1 align=\"center\"> Autores </h1>\n<hr>");
    tabelaAutor();
    g_hash_table_foreach(hash, printAutor, NULL);
    sprintf(s,"Número de autores lidos: %i\n",len);
    fprintf(indice,"<h4> %s </h4>\n",s);
    sprintf(s,"Número de autores com citações: %i\n",c);
    fprintf(indice,"<h4> %s </h4>\n",s);
    sprintf(s,"Número de citações lidas: %i\n",ncits);
    fprintf(indice,"<h4> %s </h4>\n",s);

    fprintf(autores, "</table>");
	fprintf(autores,"</BODY> </HTML>");
    fprintf(indice,"</BODY> </HTML>");
	fclose(autores);
    fclose(indice);
    return 0;
}



// função auxiliar para remover espaços
void removeSpaces(char *str){ 
    int count = 0; 
    for (int i = 0; str[i]; i++) 
        if (str[i] != ' ') 
            str[count++] = str[i]; 
    str[count] = '\0'; 
} 

void insertTranslation(FILE* f, char* t){
    fprintf(f,"<p>%s</p>\n",t);
}

void tabelaAutor(){
    fprintf(autores, "<style>table, th, td { border: 1px solid black;} </style>");
    fprintf(autores, "<table>");
    fprintf(autores, "<tr>");
    fprintf(autores, "<th>Autor</th>");
    fprintf(autores, "<th>Numero de Citações</th>");
    fprintf(autores, "</tr>");
}


gboolean printAutor(gpointer key, gpointer value, gpointer data){
    char aux[10*1024];
    c++;
    filelink = strdup(key);
    removeSpaces(filelink);
    sprintf(aux,"autores/%s.html",filelink);
    sprintf(r,"<li><a href=%s> %s </a></li>",aux,key);
    fprintf(autores, "<HTML> <BODY> <meta charset='UTF-8'/>");
    fprintf(autores, "<tr>");
    fprintf(autores, "<td>%s</td>\n",r);
	fprintf(autores, "<td>%d</td>",*((int *)value));
    fprintf(autores, "</tr>");
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

void insertQuote(FILE* f, char* quote){
    fprintf(f,"<p><b>-</b>"); 
    fprintf(f," %s</p>\n",quote);
}

