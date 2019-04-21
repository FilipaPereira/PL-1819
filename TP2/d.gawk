BEGIN                                   { RS="\nNIL"; FS=";"; print "graph {" > "grafo.dot" }
NR > 1                                  { split($8, array, /[#][\n\t\r]/); for(i in array) print $2 "--" array[i] ";" > "grafo.dot"; split($9, array2, /[#][\n\t\r]/); for(i in array2) print $2 "--" array2[i] ";" > "grafo.dot"}
END                                     { print "}" > "grafo.dot" }





