print (){
E='<MBean "kafka">
  ObjectName "kafka.server:type=BrokerTopicMetrics,name=BytesInPerSec,topic='$1'"
  InstancePrefix "OneMinuteRate-'$1'-"
  InstanceFrom "name"
  <Value >
    Type "current"
    Table false
    PluginName "KAFKA"
    Attribute "OneMinuteRate"
  </Value>
</MBean>
'
echo -e "$E"
}

for i in `cat ./topic.txt`
do
print $i

done