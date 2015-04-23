echo -e "1234\nfgfgf=[.{.url=jkjkjk\ntytyt"|awk '
BEGIN{a=1;}
function rr(){

a=a+1
return a
}
{

print rr()
if ($0 ~ "=\\[.{.url"   ) print "jkjkjkjkjkj"

}'