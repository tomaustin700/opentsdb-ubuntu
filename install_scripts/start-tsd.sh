#!/bin/sh
tsdtmp=${TMPDIR-'/run'}/tsd    # For best performance, make sure
sudo mkdir -p "$tsdtmp"             # your temporary directory uses tmpfs
./opentsdb/build/tsdb tsd --port=4242 --staticroot=opentsdb/build/staticroot --cachedir="$tsdtmp" &

