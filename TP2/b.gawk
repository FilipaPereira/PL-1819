BEGIN                                   { RS="\nNIL"; FS=";"}
NR==1                                   {print "#Registo;" $2 ";" $3 ";" $4 ";" $5 > "registos.csv"; i++}
NR>1                                    {print i ";" $2 ";" $3 ";" $4 ";" $5 > "registos.csv"; i++}
END                                     { }



