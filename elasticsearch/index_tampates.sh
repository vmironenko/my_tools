#!/bin/bash

curl -XPUT elastic-server:9200/_template/template_adserver -d '
{
  "template" : "ad*",
  "mappings":{
   "fluentd":{
    "properties":{
        "ad_host":{"type":"string", "index" : "not_analyzed" },
        "body":{"type":"string", "index" : "not_analyzed" },
        "class":{"type":"string", "index" : "not_analyzed" },
        "class_except_1":{"type":"string", "index" : "not_analyzed" },
        "class_except_2":{"type":"string", "index" : "not_analyzed" },
        "class_except_3":{"type":"string", "index" : "not_analyzed" },
        "class_except_4":{"type":"string", "index" : "not_analyzed" },
        "class_except_5":{"type":"string", "index" : "not_analyzed" },
        "environ":{"type":"string", "index" : "not_analyzed" },
        "file":{"type":"string", "index" : "not_analyzed" },
        "level":{"type":"string", "index" : "not_analyzed" }
        }
   }   
  }
}
'

