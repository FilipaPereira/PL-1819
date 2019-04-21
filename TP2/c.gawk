BEGIN                                   { RS="\nNIL"; FS=";"; print "Tipo de processo; Número de Registos" > "tipos.csv"}
NR>1 && $10 != ""                               { array[$10]++;}
END                                     { for(i in array) print i ";" array[i] > "tipos.csv"}




