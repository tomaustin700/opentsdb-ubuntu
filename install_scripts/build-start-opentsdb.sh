#!/bin/sh
set -x verbose
sudo apt-get install gnuplot
rm -rf opentsdb
git clone git://github.com/OpenTSDB/opentsdb.git
cd opentsdb
./build.sh
