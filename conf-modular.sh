#!/bin/bash

F="`cat /home/vmironenko/gerrit/modular-adserver/modular-adserver/adserver/src/main/resources/reference.conf`"
#F="`cat /home/vmironenko/gerrit/adserving/adserving/adserver/src/main/resources/fixed-configuration.properties`"
#F="`cat /home/vmironenko/gerrit/adserving/adserving/adserver/src/main/resources/runtime-configuration.properties`"

DD="`cat /home/vmironenko/modular-adserver/playbooks/roles/adserver/configure/templates/configuration.j2`"

echo "$DD"|awk 'BEGIN{
B=""
}
{
do {
 if ($0 ~ ".*[\\[{]$") {
    if (B == "" ) {
	B=$1; } else {
        B=B "." $1
        }
 } else {
 if ($0 ~ "^[ ]*[}\\]]$") gsub(".[^.]*$","",B)
 if ($0 ~ "{{"){
    gsub("^ *","")
    gsub("ZZZ1","ZZZ2",B)
    gsub("=\\[","ZZZ1",B)
    print B "." $0
  }
 }
}while (getline) 
}' >/tmp/conf.txt;
#cat /tmp/conf.txt
#exit
while read ii
do
i="`echo $ii|sed 's/=\[.{.url/Z.url/g'`"

FF="`echo $i|sed 's/=.*$//g'`"
E="`echo $i|sed 's/^[^ = ]*=//g'`"
[ -z "$TT" ] && TT="$F"

T="`echo \"$TT\"|awk -v \"I=$i\" -v \"FF=$FF\" -v \"E=$E\" 'BEGIN{
B=\"\"
}
{
do{
# if ($0 ~ \"[ ]*[a-zA-Z][ =][\\\\[{]$\") {
 if ($0 ~ \".*[\\\\[{]$\") {
    if (B == \"\" ) {
	B=$1 } else {
        B=B \".\" $1
        }
 } else {
 if ($0 ~ \"^[ ]*[}\\\\]]$\") { 
    gsub(\".[^.]*$\",\"\",B)
 } else {
 D=$1
 gsub(\"^[ \t]*\",\"\",D)
 gsub(\"ZZZ1\",\"ZZZ2\",B)
 gsub(\"=\\\\[\",\"ZZZ1\",B)
 C=B \".\" D
 if ( C ~ FF"=" ) {
   gsub( \"=.*$\",\"\" )
   $0=$0 "=" E
#  print
 }}
}
print 
}while (getline)
}'`"
TT="`echo \"$T\"`"
done < /tmp/conf.txt
echo "$TT" | grep  'localhost' >/dev/null && echo "!!!localhost!!!!" >&2
echo "$TT" 
