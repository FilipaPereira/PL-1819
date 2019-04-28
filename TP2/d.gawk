BEGIN             { RS="\nNIL"; FS=";"; print "graph {" > "grafo.dot" }
NR > 1            { split($8, array, /[#][\n\t\r]+/);
                        for(i in array) {
                            gsub(/\"/,"",array[i]);
                            if(array[i]!="")
                                print "\x22" $2 "\x22 -- \x22" array[i] "\x22;" > "grafo.dot";
                        }
                        split($9, array2, /[#][\n\t\r]+/);
                        for(i in array2){
                            gsub(/\"/,"",array2[i]);
                            if(array2[i]!="")
                                print "\x22" $2 "\x22 -- \x22" array2[i] "\x22;" > "grafo.dot";
                    }
                  }
END               { print "}" > "grafo.dot" }







