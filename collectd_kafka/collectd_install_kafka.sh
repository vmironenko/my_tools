set -x
yum -y install http://anfadmin.ucsd.edu/linux/CentOS/6/x86_64/libcollectdclient-5.4.1-1.el6.x86_64.rpm
yum -y install  http://anfadmin.ucsd.edu/linux/CentOS/6/x86_64/collectd-5.4.1-1.el6.x86_64.rpm
yum -y install  http://anfadmin.ucsd.edu/linux/CentOS/6/x86_64/collectd-java-5.4.1-1.el6.x86_64.rpm

echo "export LD_LIBRARY_PATH=/usr/java/default/jre/lib/amd64/server:/usr/lib/java" > /etc/sysconfig/collectd
cp -f fast-jmx-1.1-SNAPSHOT.jar /usr/share/collectd/java/fast-jmx-1.1-SNAPSHOT.jar
cat  collectd_kafka.conf |sed "s/ZZZ/`hostname`/" > /etc/collectd.conf
mkdir -p /opt/collectd_system_plugin
cp -f iostat_collectd_plugin.sh /opt/collectd_system_plugin/iostat_collectd_plugin.sh
cp -f vmstat_collectd_plugin.sh /opt/collectd_system_plugin/vmstat_collectd_plugin.sh
cp -f df_collectd_plugin.sh /opt/collectd_system_plugin/df_collectd_plugin.sh
chkconfig --add collectd
chkconfig collectd on
service collectd restart