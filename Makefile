all: citacoes traducoes estatisticas
	mkdir -p autores

citacoes: ex1.l
	flex ex1.l
	cc lex.yy.c -o citacoes `pkg-config --cflags --libs glib-2.0`

traducoes: ex2.l
	flex ex2.l
	cc lex.yy.c -o traducoes `pkg-config --cflags --libs glib-2.0`

estatisticas: ex3.l
	flex ex3.l
	cc lex.yy.c -o estatisticas `pkg-config --cflags --libs glib-2.0`

