#!/bin/bash

cat ./logging.xml.j2|grep "{{" > /tmp/log_conf.txt


F="`cat /home/vmironenko/gerrit/adserving/adserving/adserver/src/main/resources/logging.xml`"

while read  i
do
B="`echo \"$i\"|sed 's/{{.*$//g'`"
T="`echo \"$F\"|awk -v I=\"$i\" -v L=\"$B\" '{ 
 if( $0 ~ L ) {
    print "    " I
 } else print ;
}'`"
     
F="`echo  \"$T\"`"     
done < /tmp/log_conf.txt
echo -e "$F\n"|awk 'BEGIN{A="BEGIN";}
{
do{
if ($0 ~ "<!--[ ]*<appender-ref") {
gsub("<!--[ ]*<","<")
gsub(">[ ]*-->",">")
print 
getline
} else { 
 if (A != "BEGIN")   print A; 
}
A=$0
}while (getline)

}'|sed 's/DEBUG/WARN/g'








