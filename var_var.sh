n=$#
while [ "$n" -gt 0 ]
do
var=${!n}
n=$[n-1]
eval $var
done

echo $tt $mm