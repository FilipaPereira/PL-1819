BEGIN                                   { RS="\nNIL"; FS=";"}
                                {print $2 ";" $3 ";" $4 ";" $5 > "registos.csv"}
END                                     { print "Registos Lidos;"(NR-1) > "registos.csv"}



