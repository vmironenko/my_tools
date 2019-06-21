#!/bin/bash

n_tabl=1

# setting integrated functions
pars(){
    n=$#
    i=1
    while [ "$i" -le "$n" ]
	do
	I="$(echo ${!i})"
	echo "$I"|grep -qE "attr([)]*)" && {
	    attr="`echo $I|sed 's/attr(\([^)]*\)).*/\1/g'`"
	    I="`echo $I|sed 's/attr([^)]*)//g'`"
	}
	i=$[i+1]
	[ -z "$I" ] && I="&nbsp;"
	echo -e "\t<$itm $attr>$I</$itm>"
	attr=''
    done
}

table(){
if [ -z "$1" ]
    then
        echo "Table error: There isn't any parameters"
	exit 1
fi
itm="th"
echo "<table border=1 class=\"table_${n_tabl}\">"
echo ""|cat $1 - | while read line
 do
    [ -z "$line" ] && continue
    echo " <tr>"
    eval "pars $line"
    itm='td'
    echo " </tr>"
 done
echo "</table>"
}

repeat(){  #repeat 'template%s...%s...' file_name [el(it's to erase lasts character)]
 temp=$1
 {
  echo ""|cat $2 - | while read line
   do
   [ -n "$line" ] && printf "$temp" $line
   done
 } | {
  if [ "$3" == "el" ]
   then
    cat -|sed 's/.$//g'
   else
    cat -
  fi
 }
}

# the handler
echo ""|cat $1 - | while read line
 do
    echo "$line"|grep -qE "F\([^)]*\)" && {
	func="`echo "$line"|sed 's/^.*F(\([^)]*\)).*/\1/g'`"
	echo -n "$line"|sed 's/^\(.*\)F(.*/\1/g'
	echo -n "$(eval $func)"
        n_tabl=$((n_tabl+1))
	echo  "$line"|sed 's/^.*F([^)]*)\(.*\)/\1/g'
    } || echo "$line"
 done
