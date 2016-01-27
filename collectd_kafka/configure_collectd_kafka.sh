set -x
cat  collectd_kafka.conf |sed "s/ZZZ/`hostname`/" > /etc/collectd.conf
service collectd restart
