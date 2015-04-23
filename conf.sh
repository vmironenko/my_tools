#!/bin/bash

F="`cat /home/vmironenko/gerrit/adserving/adserving/adserver/src/main/resources/configuration.properties`"
#F="`cat /home/vmironenko/gerrit/adserving/adserving/adserver/src/main/resources/fixed-configuration.properties`"
#F="`cat /home/vmironenko/gerrit/adserving/adserving/adserver/src/main/resources/runtime-configuration.properties`"


cat ./configuration.properties.j2|grep "{{" > ./tt

while read  i
do
B="`echo $i|sed 's/=.*$//g'`"
T="`echo \"$F\"|awk -v \"I=$i\" -v \"L=$B\" '
{ if( $0 ~ L\"=\" ) { 
    print I 
 } else print ; 
}'`"

F="`echo \"$T\"`"
done <./tt
echo "$F"
