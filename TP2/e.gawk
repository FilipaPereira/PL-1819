BEGIN    { RS="\nNIL"; FS=";"; print "Instituições; Número de Processos" > "donos.csv"}
NR>1 	 { split($12,array,/[#]+[\n\t\r]*/);
            for(i in array) {
			    gsub(/\"/,"",array[i]);
                array2[array[i]]++
            }
         }
END      { for(i in array2) if(i != "") print i ";" array2[i] > "donos.csv";}

