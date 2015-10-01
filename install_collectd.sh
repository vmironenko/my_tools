cd /tmp
rm -rf /tmp/collectd 2>/dev/null
mkdir /tmp/collectd
cd /tmp/collectd
wget wget https://github.com/placeiq/adserving-devops/releases/download/collectd_prod.tar-v1.0/collectd_prod.tar &&
tar xvf collectd_prod.tar &&
./collectd_install_prod.sh
