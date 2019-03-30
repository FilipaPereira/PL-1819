all: citacoes traducoes estatisticas
	mkdir -p autores

citacoes: ex1.l
	flex ex1.l
	gcc -Wall -Wextra -g lex.yy.c -o citacoes `pkg-config --cflags --libs glib-2.0`

traducoes: ex2.l
	flex ex2.l
	gcc -Wall -Wextra -g lex.yy.c -o traducoes `pkg-config --cflags --libs glib-2.0`

estatisticas: ex3.l
	flex ex3.l
	gcc -Wall -Wextra -g lex.yy.c -o estatisticas `pkg-config --cflags --libs glib-2.0`

clean:
	rm -f lex.yy.c
	rm -f citacoes
	rm -f traducoes
	rm -f estatisticas
	rm -rf autores/
	rm -f quotes.html
	rm -f traducoes.html
	rm -f autores.html
	rm -f indice.html


