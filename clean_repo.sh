#!/bin/bash

com(){
 for i in $A
 do
  ls -t $P/$i-*|grep $filter|
  awk -v NUM=$N '{
    if (NUM >0 ){
#    print rm$0
;
    } else   {
        print "rm "$0
	system("rm -f " $0)
    }
    NUM-=1
  }'
 done
}

clean_files(){
 # remove shapshot older on 14 day
 find $P -name "*snapshot*" -o -name "*SNAPSHOT*" -o -name "*_AA*" -mtime +14 -exec bash -c 'echo "rm {}";rm -f {}' \;

 # remove  shapshots with a iteration for datamart
 [ $datamart == 'y' ]&& {
  filter="-iE snapshot|_AA"
  A=`ls $P|grep .rpm|sed 's/-[0-9]*\.noarch.rpm//g'|grep $filter|uniq`
  N=3
  com
 }

 # remove GA with a iteration
 filter="-viE snapshot|_AA"
 A=`ls $P|grep .rpm|sed 's/-[0-9]*\.noarch.rpm//g'|grep $filter |uniq`
 N=1
 com

 # remove GA > N 
 filter="-viE snapshot|_AA"
 A=`ls $P|grep .rpm|grep $filter|sed 's/-[0-9].*$//g'|uniq`
 N=3
 com
}

P="/var/www/repository/adserving/centos/6/noarch"
datamart='n'
clean_files
P="/var/www/repository/datamart/centos/6/noarch"
datamart='y'
clean_files
