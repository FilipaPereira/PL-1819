BEGIN                                  { RS="\n[ \r\t]*\n"; FS=";"}
NR == 1                                {print $0 > "processado.csv"}
NR>1 && $1 == "" && $0 !~ /[;]{34}/    {gsub(/\\n/, " "); print "NIL" $0 > "processado.csv"}
NR>1 && $1 && $0 !~ /[;]{34}/          {gsub(/\\n/, " "); print $0 > "processado.csv"}
END                                    { }



