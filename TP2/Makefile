run:
	gawk -f a.gawk formacao.csv
	gawk -f b.gawk processado.csv
	gawk -f c.gawk processado.csv
	gawk -f d.gawk processado.csv
	gawk -f e.gawk processado.csv

a: 
	gawk -f a.gawk formacao.csv

b: 
	gawk -f b.gawk processado.csv

c: 
	gawk -f c.gawk processado.csv

d: 
	gawk -f d.gawk processado.csv

E: 
	gawk -f e.gawk processado.csv

clean:
	rm -f processado.csv
	rm -f registos.csv
	rm -f tipos.csv
	rm -f grafo.dot
	rm -f donos.csv

