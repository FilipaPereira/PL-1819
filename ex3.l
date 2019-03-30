%{
    #include<stdio.h>
    #include<stdlib.h>
    #include<string.h>
    #include <glib.h>
    #include <ctype.h>
    GHashTable* hash;
    FILE * file;
    FILE* indice;
    FILE* traducoes;
    FILE* autores;
    FILE* page;
    char* nome="", *auxnome="";
    int conta = 0, ncits = 0;
    char s[50];
    char filename[200];
    int len=0;
    char r[200];
    char* filelink;
    void insertTranslation(FILE* f, char* t);
    gboolean printAutor(gpointer key, gpointer value, gpointer data);
    void insertAutor(char * autor);
    void insertQuote(FILE* f, char* quote);
    void tabelaAutor();
    void removeSpaces(char *str);
%}

%x AUTOR
%x NOME
%x QUOTE
%x PAGE

%%
^([ ]*"<page>")                              { nome=""; BEGIN PAGE; }
<PAGE>"<text".*"{{Autor"                     { BEGIN AUTOR; len++; }
<AUTOR>"|"[ ]*("Wikipedia")[ ]*"="[ ]*       { BEGIN NOME; }
<NOME>[^("|"|\n)]*                           { nome = strdup(yytext); auxnome = strdup(nome); removeSpaces(auxnome); sprintf(filename,"autores/%s.html",auxnome); 
                                                page = fopen(filename, "w+"); 
                                                fprintf(page,"<html><head><meta charset='UTF-8'/>\n </head><body><ul>\n"); 
                                                BEGIN INITIAL; }
^([*][ ]*"&quot;")                           { insertAutor(nome); BEGIN QUOTE; }
<QUOTE>[^\n]*                                { insertQuote(page,yytext); fprintf(file,"<p><b>%s</b>",nome); 
                                                fprintf(file," %s</p>\n",yytext); ncits++; BEGIN INITIAL; }
<AUTOR>^("[[Categoria")                      { BEGIN PAGE; }
<PAGE>^([*][ ]*"&quot;")                     { BEGIN QUOTE; }
[*].*\n[:]*[-]*[ ]*[']*(?i:("Tradução"|"Tradução literal"))[:]?[^\n]*      {insertTranslation(traducoes,yytext); conta++;}
[*]" &quot;".*\n"**"[ ]?"Tradução:"[^\n]*                                  {insertTranslation(traducoes,yytext); conta++;}
[*][ ]*"&quot;".*\n[*]*"Original"[ ]*[:]?[^\n]*                            {insertTranslation(traducoes,yytext); conta++;}
[*][ ]?.*\n[*]{2}[']{2}"Tradução''"[:][^\n]*                               {insertTranslation(traducoes,yytext); conta++;}
[*][ ]*[']{3}.*\n[*]{2}[ ]*[']{2}"Tradução"[^\n]*                          {insertTranslation(traducoes,yytext); conta++;}
[*]" &quot;".*"&quot;"\n": "[A-Za-z][^\n]*                                 {insertTranslation(traducoes,yytext); conta++;}
[:].*[']{3}.*\n[:]+"Tradução literal"[^\n]*                                {insertTranslation(traducoes,yytext); conta++;}
[*].*\n[:][ ]"&lt;u&gt;"("Tradução"|"Literalmente")[:]"&lt;/u&gt;"[^\n]*   {insertTranslation(traducoes,yytext); conta++;}
<*>(.|\n)                                    {;}
%%


int yywrap(){
    return 1;
}


int main(){
    indice = fopen("indice.html","w+");
    autores = fopen("autores.html", "w+");
    file = fopen("quotes.html","w");
    traducoes = fopen("traducoes.html", "w+");

    fprintf(file, "<HTML> <BODY> <meta charset='UTF-8'/>");
    fprintf(file,"<h1 align=\"center\"> Citações </h1>\n<hr>");
    
    fprintf(traducoes,"<html><head><meta charset='UTF-8'/>\n </head><body><ul>\n");
    fprintf(traducoes,"<h1 align=\"center\"> Lista de Traduções </h1>\n<hr>");

    hash = g_hash_table_new(g_str_hash, g_str_equal);
    
    yylex();
    fprintf(indice,"%s","<html> <head> <meta charset='UTF-8'/>  <style> table, th, td { border: 1px solid black; border-collapse: collapse; } th, td { padding: 5px; } th { text-align: left; } </style> </head> <body>");
    fprintf(indice,"<h1 align=\"center\"> Wiki Quotes </h1>\n<hr>");
    fprintf(indice,"<li> <a href='%s'> %s </a></li>\n","autores.html","Estatísticas de Autores");
    fprintf(indice,"<li> <a href='%s'> %s </a></li>\n","quotes.html","Lista de Citações");
    fprintf(indice,"<li> <a href='%s'> %s </a></li>\n","traducoes.html","Lista de Traducoes");
    sprintf(s,"Número de traduções lidas: %i\n",conta);
    fprintf(indice,"<h3> %s </h3>\n",s);
    sprintf(s,"Número de autores lidos: %i\n",len);
    fprintf(indice,"<h3> %s </h3>\n",s);
    sprintf(s,"Número de citações lidas: %i\n",ncits);
    fprintf(indice,"<h3> %s </h3>\n",s);
    fprintf(autores, "<HTML> <BODY> <meta charset='UTF-8'/>");
    fprintf(autores,"<h1 align=\"center\"> Autores </h1>\n<hr>");
    tabelaAutor();
    g_hash_table_foreach(hash, printAutor, NULL);
    fprintf(autores, "</table>");
	fprintf(autores,"</BODY> </HTML>");
    fprintf(indice,"</BODY> </HTML>");
    fprintf(file,"</BODY> </HTML>");
    fprintf(traducoes,"</BODY> </HTML>");
    fclose(traducoes);
    fclose(file);
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
    filelink = (char*)malloc(sizeof(key));
    strcpy(filelink,key);
    removeSpaces(filelink);
    strcat(filelink,".html");
    sprintf(r,"<li><a href=%s> %s </a></li>",filelink,key);
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

