#!/bin/sh
set -x verbose
./install_scripts/install-system-prereq.sh
./install_scripts/install-java6.sh
./install_scripts/hbase-hadoop-prereqs.sh
./install_scripts/clean-install-hbase.sh
./install_scripts/build-start-opentsdb.sh
sleep 10
./install_scripts/create-opentsdb-tables.sh
sleep 10
./install_scripts/start-tsd.sh
sleep 10
./install_scripts/create-stats.sh

