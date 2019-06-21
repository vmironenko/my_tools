#!/usr/bin/python
import json
import jmespath
import os
import re

with open("dashboard.json" , "r") as f:
            data = json.load(f)

d=data['dashboard']["rows"][0]["panels"][6]['targets']

qq = ''
for s in d[0]['select']:
  if len(qq) > 0:
        qq = qq + ', '
  qqq=''
  for ss in s:
      if ss['type'] == 'field':
        qqq = '"' + ss['params'][0] + '"'
        continue
      if ss['type'] != 'math' and ss['type'] != 'alias':
        if len(ss['params']) > 0:
          param = ',"' + ss['params'][0] + '"'
        else: param = ''
        qqq = ss['type'] + '(' + qqq + param + ')'
        continue
      if ss['type'] == 'math':
        qqq = qqq + ss['params'][0]
        continue
      if  ss['type'] == 'alias':
        qqq = qqq + ' AS ' + '"' + ss['params'][0] + '"'
  qq = qq + qqq
policy = ''
if d[0]['policy'] != 'default':
   policy = '"' + d[0]['policy'] + '".'
measurement = '"measurement"'
if 'measurement' in d[0]:
   measurement = '"' + d[0]['measurement'] + '"'

cond = ''
l = ''
for c in d[0]['tags']:
    if cond != '':
      l = ' AND '
    cond = cond + l + c['key'] + c['operator'] + c['value']

group = 'GROUP BY'
for g in d[0]['groupBy']:
  group = group + ' ' + g['type'] + '(' + g['params'][0] + ')'

print "SELECT " + qq + ' FROM ' + policy + measurement + ' WHERE ' + cond + group


