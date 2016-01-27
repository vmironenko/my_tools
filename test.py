# The Grinder 3.11
# HTTP script recorded by TCPProxy at Mar 3, 2014 12:26:07 PM
from __future__ import with_statement
import re
import string
import random
import time
import hashlib
from functools import partial

from HTTPClient import NVPair
from net.grinder.script import Test
from net.grinder.script.Grinder import grinder
from net.grinder.plugin.http import HTTPRequest

GATEWAY = 'gateway'
BIDDER = 'bidder'
ENRICHER = 'enricher'
BSWITCH = 'bswitch'
GW_BSW = 'gw_bsw'
MIX = 'mix'
APPBOY='appboy'

p = grinder.getProperties()
g = lambda name: 'grinder.%s' % name

threads = int(p.getProperty(g('threads')))

# These definitions at the top level of the file are evaluated once,
# when the worker process is started.
appname = p.getProperty(g('target.appname'), GATEWAY)
host = p.getProperty(g('target.host'), 'localhost')
ssl = p.getBoolean(g('target.ssl'), False)
filename = p.getProperty(g('target.data'), '%s_sample.txt' % appname)
filename_bsw = p.getProperty(g('bsw.data'), 'bsw_sample.txt')
num_gw =  p.getInt(g('num_gw'), 0)
# threads perform requests one by one with specified interval (in ms)
# by default all the treads start together
thread_rampup = p.getInt(g('thread_rampup_sleep_time'), 0)
make_impression_requests = p.getBoolean(g('make_impression_requests'), False);

base_url = 'http%s://%s' % ('s' if ssl else '', host)
headers = (NVPair('User-Agent', 'grinder'), NVPair('Accept', '*/*'))

def get_bidder_dataset(filename):
    dataset = []
    with open(filename) as f:
        for line in f:
            if line:
                path, data = line.split(' ', 1)
                dataset.append((path.strip(), data.strip()))
    return dataset


if appname == BIDDER:
    dataset = get_bidder_dataset(filename)

elif appname == BSWITCH:
    dataset_bsw = get_bidder_dataset(filename)

elif appname == GW_BSW:
    dataset_bsw = get_bidder_dataset(filename_bsw)

elif appname == GATEWAY or appname == GW_BSW:
    dataset = []
    with open(filename) as f:
        sub = re.sub
        for line in f:
            dataset.append(line)

elif appname == MIX:
    dataset = []
    with open(filename) as f:
        sub = re.sub
        for line in f:
            dataset.append(line)

elif appname == ENRICHER:
    dataset = []
    with open(filename) as f:
        sub = re.sub
        for line in f:
             line = sub(r'&RI=[^&]*|\n|\r', '', line) + '&RI='
             dataset.append(line)

elif appname == APPBOY:
    dataset = []
    with open(filename) as f:
        for line in f:
            if line:
                data1, data2 = line.split(' ', 1)
                dataset.append((data1.strip(), data2.strip()))




def initial_sleep(rampup):
    if rampup:
        grinder.sleep(rampup * 60 * (grinder.threadNumber / threads))


if appname == BIDDER:
    def do_test():
        if make_impression_requests:
            import re
            p = re.compile(r'tracking_pixel.gif(.*?)"')
            request1.setHeaders(headers)
            request1.setUrl(base_url)
        POST = request.POST
        initial_sleep(thread_rampup)
        while True:
            for path, data in dataset:
                res = POST(path, data)
                if make_impression_requests:
                    pars = p.search(res.getText())
                    if pars:
                        request1.GET('/i' + pars.group(1))

elif appname == BSWITCH:
    def do_test():
        import re
        p = re.compile(r'.*vast_url":"([^"]*)".*')
        p1 = re.compile(r'.*nurl":"([^"]*)".*')
        POST = request.POST
        initial_sleep(thread_rampup)
        while True:
            for path, data in dataset_bsw:
                res = POST(path, data)
                if make_impression_requests:
                    res = res.getText()
                    pars = p.search(res)
                    pars1 = p1.search(res)
                    if pars:
                        vast_url = pars.group(1)
                        request1.setHeaders(headers)
                        request1.GET(vast_url)
                    if pars1:
                        nurl = pars1.group(1)
                        request1.setHeaders(headers)
                        request1.GET(nurl)


elif appname == GATEWAY:
    def do_test():
        GET = request.GET
        initial_sleep(thread_rampup)
        while True:
            for data in dataset:
                GET(data, None)

elif appname == MIX:
    def do_test():
        import re
        begining = re.compile(r'/ {')
        GET = request.GET
        POST = request.POST
        initial_sleep(thread_rampup)
        while True:
            for data  in dataset:
                pars=begining.search(data)
                if pars:
                     data1=data.split(' ',1)[0]
                     data2=data.split(' ',1)[1]
                     POST(data1, data2)
                else:
                    GET(data, None)


elif appname == GW_BSW:
    def do_test():
        import re
        p = re.compile(r'.*vast_url":"([^"]*)".*')
        p1 = re.compile(r'.*nurl":"([^"]*)".*')
        POST = request.POST
        GET = request.GET
        gmtime = time.gmtime
        get_time = time.time
        initial_sleep(thread_rampup)
        get_today = partial(time.strftime, '%Y-%m-%d')
        if grinder.threadNumber + 1 > num_gw:
            while True:
                for path, data in dataset_bsw:
                    res = POST(path, data)
                    if make_impression_requests:
                        res = res.getText()
                        pars = p.search(res)
                        pars1 = p1.search(res)
                        if pars:
                            vast_url = pars.group(1)
                            request1.setHeaders(headers)
                            request1.GET(vast_url)
                        if pars1:
                             nurl = pars1.group(1)
                             request1.setHeaders(headers)
                             request1.GET(nurl)
        else:
            while True:
                for data in dataset:
                    GET(data, None)






elif appname == ENRICHER:
    def do_test():
        GET = request.GET
        initial_sleep(thread_rampup)
        request1.setHeaders(headers)
        request1.setUrl(base_url)
        GET1 = request1.GET
        while True:
            for data in dataset:
                rnd=str(random.random())
                res = GET(data+rnd, None)
                if make_impression_requests:
                    if res.getText():
                        GET1('/i/?AP=AN&RI=' + rnd , None)

elif appname == APPBOY:
    def do_test():
        GET = request.GET
        request1.setHeaders(headers)
        request1.setUrl(base_url)
        GET1 = request1.GET
        date = str(int(time.time()))
        initial_sleep(thread_rampup)
        import re
        p = re.compile(r'piqid":[ ]*"([^"]*)"')
        co = 0
        ts = '&TS=' + date
        while True:
            for data1, data2 in dataset:
        	co += 1
                res = GET1(data1, None)
                res = res.getText()
                pars = p.search(res)
                if not co & 1:
            	    t = ts
            	else: 
            	    t = '' 
		if pars:
            	    id = pars.group(1)
        	    GET("/dataex/data/?" + data2 + '&DI=' + id  + t)


def TestRunner():
    return do_test

test = Test(1, appname)
request = HTTPRequest()
request.setUrl(base_url)
request1 = HTTPRequest()
request.setHeaders(headers)
test.record(request, HTTPRequest.getHttpMethodFilter())
