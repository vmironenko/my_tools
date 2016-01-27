#!/bin/bash
set -eo pipefail
pid_own="$$"

HOSTNAME="${COLLECTD_HOSTNAME:-$(hostname)}"
INTERVAL="${COLLECTD_INTERVAL:-1}"
INTERVAL="`echo $INTERVAL|sed s'#\..*##'`"
HOSTNAME="`echo $HOSTNAME|sed 's#\.#_#g'`"

func_df() {
 while sleep "$INTERVAL"; do
   df -hlP|awk -v HOSTNAME="$HOSTNAME" -v interval="$INTERVAL" '!/Used|Avail|^$/{
   disk = $1
   n=0
   if (NF==1) {getline; n=1;}
   gsub("%","")
   print "PUTVAL "  HOSTNAME  "/disk_df/gauge-"  disk  "/use"    " interval=" interval  " N:"  $(5-n) ;
   print "PUTVAL "  HOSTNAME  "/disk_df/gauge-"  disk  "/free"    " interval=" interval  " N:"  100 - $(5-n) ;
   }'
 done
}


func_df &
pid_func="$!"


pid_df="`ps -ef|grep "df "|grep $pid_func|awk '{print $2}'`"
trap "kill  $pid_df $pid_func; kill -9 $pid_own; exit;" 1 2 15
read e

