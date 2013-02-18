#!/bin/sh
echo stats | nc -w 1 localhost 4242 \
| awk '{ print $1 }' | sort -u \
| xargs ./opentsdb/build/tsdb mkmetric
