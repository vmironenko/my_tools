#!/bin/bash

F="`cat /home/vmironenko/gerrit/modular-adserver/modular-adserver/adserver/src/main/resources/reference.conf`"
#F="`cat /home/vmironenko/gerrit/adserving/adserving/adserver/src/main/resources/fixed-configuration.properties`"
#F="`cat /home/vmironenko/gerrit/adserving/adserving/adserver/src/main/resources/runtime-configuration.properties`"

DD="`cat /home/vmironenko/adserving-devops/playbooks/roles/adserver/configure/templates/configuration.j2`"

echo "$DD"|awk 'BEGIN{
B=""
}{

 if ($0 ~ "[ ]*[a-zA-Z] {$") {
    if (B == "" ) {
	B=$1; } else {
        B=B "." $1
        }
 }
 if ($0 ~ "^[ ]*}$") gsub(".[^.]*$","",B)

 if ($0 ~ "{{"){
    gsub("^ *","")
    print B "." $0
 }
}' >/tmp/conf.txt;

while read i
do
FF="`echo $i|sed 's/=.*$//g'`"
E="`echo $i|sed 's/[^=]*=//g'`"
[ -z "$TT" ] && TT="$F"

T="`echo \"$TT\"|awk -v \"I=$i\" -v \"FF=$FF\" -v \"E=$E\" 'BEGIN{
B=\"\"
}{
 if ($0 ~ \"[ ]*[a-zA-Z] {$\") {
    if (B == \"\" ) {
	B=$1 } else {
        B=B \".\" $1
        }
 }
 if ($0 ~ \"^[ ]*}$\") gsub(\".[^.]*$\",\"\",B)
 D=$1
 gsub(\"^[ \t]*\",\"\",D)
 C=B \".\" D
 if ( C ~ FF ) {
   gsub(\"=.*\",\"=\"E)
#  print B
 }
print 
}'`"
TT="`echo \"$T\"`"
done </tmp/conf.txt
echo "$TT" |sed 's/localhost:8080/{{ openrtb_url }}/g'
