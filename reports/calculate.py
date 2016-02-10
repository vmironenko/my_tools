#!/usr/bin/env python
# Calculate mean and max from datapoints

from __future__ import print_function

import sys
from json import load


def usage():
    print('Usage: %s <file>' % sys.argv[0])
    sys.exit(1)


def main(filename):
    with open(filename) as f:
        data = load(f)
    datapoints = [0,0]
    for node in data:
        datapoints += [d for d, t in node['datapoints'] if d is not None]
    print(sum(datapoints)/len(datapoints))
    print(max(datapoints))


if __name__ == '__main__':
    try:
        main(sys.argv[1])
    except IndexError:
        usage()
    except Exception as e:
        print('Unhandled exception: %r' % e)
        sys.exit(127)
