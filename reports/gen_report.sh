#!/bin/bash

n_tabl=1

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
echo "<table border=1 class=\"tabl${n_tabl}\">"
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

clean() {
    cat - |sed "s/++++n++++/ /g; s/++++q++++/'/g; s/++++t++++/\t/g"
}

replace() {
    n=$#
    i=1
    while [ "$i" -le "$n" ]
	do
	L="`echo -n ${!i}`"
	echo -n "$L"|grep -qE "F\(" && {
		EXEC="`echo -n $L |clean |sed 's/F(\([^)]*\))/\1/g'`"
		echo -n "$(eval $EXEC)"
	} || echo -n "$L"|clean
	i=$[i+1]
    done
    echo -e '\n'
}

echo ""|cat "$1" - |sed "s/ /++++n++++/g; s/'/++++q++++/g; s/\t/++++t++++/g"| while read line
 do
    echo -n "$line"|grep -qE "F([^)]*)" && {
	replace `echo -n "$line"|sed 's/\(F([^)]*)\)/ \1 /g'`
    
    
#	func="`echo "$line"|sed 's/^.*F(\([^)]*\)).*/\1/g'`"
#	echo -n "$line"|sed 's/^\(.*\)F(.*/\1/g'
#	echo -n "$(eval $func)"
#	n_tabl=$((n_tabl+1))
#	echo  "$line"|sed 's/^.*F([^)]*)\(.*\)/\1/g'
    } || echo "$line"|clean
 done 
 