#!/bin/sh
set -x verbose
PKG_NAME=hbase
PKG_VERS=0.94.5
PKG_FULL=$PKG_NAME-$PKG_VERS
PKG_URL=http://www.apache.org/dist/hbase
PKG_INST=${TMPDIR-'/tmp'}/tsdhbase
iface=lo`uname | sed -n s/Darwin/0/p`

#If you already have an HBase cluster, skip this step. If you're gonna be using less than 5-10 nodes, stick to a single node. Deploying HBase on a single node is easy and can help get you started with OpenTSDB quickly. You can always scale to a real cluster and migrate your data later.

killall java
rm -rf $PKG_FULL
rm -rf $PKG_INST
if [ ! -f hbase-0.94.5.tar.gz ] ; then
	wget $PKG_URL/$PKG_FULL/$PKG_FULL.tar.gz
fi
tar xfz $PKG_FULL.tar.gz

LZO_NAME=hadoop-lzo
LZO_URL=https://github.com/cloudera
# Hadoop-LZO itself:
rm -rf $LZO_NAME
git clone $LZO_URL/$LZO_NAME.git
cd $LZO_NAME

# TODO fix paths
JAVA_HOME=/usr/lib/jvm/java-6-oracle LDFLAGS='-Wl,--no-as-needed' CLASSPATH=../$PKG_FULL/lib/hadoop-core-1.0.4.jar CFLAGS=-m64 CXXFLAGS=-m64 ant compile-native tar
mkdir -p ../$PKG_FULL/lib/native
cp build/hadoop-lzo-0.4.14/hadoop-lzo-0.4.14.jar ../$PKG_FULL/lib
cp -a build/hadoop-lzo-0.4.14/lib/native/* ../$PKG_FULL/lib/native

cd ../$PKG_FULL

#Make sure to adjust the value of hbase_rootdir if you want HBase to store its data in somewhere more durable than a temporary directory. The default is to use /tmp, which means you'll lose all your data whenever your server reboots. The remaining settings are less important and simply force HBase to stick to the loopback interface (lo0 on Mac OS X, or just lo on Linux), which simplifies things when you're just testing HBase on a single node.

cat >conf/hbase-site.xml <<EOF
<?xml version="1.0"?>
<?xml-stylesheet type="text/xsl" href="configuration.xsl"?>
<configuration>
  <property>
    <name>hbase.rootdir</name>
    <value>file:///$PKG_INST/hbase-\${user.name}/hbase</value>
  </property>
  <property>
    <name>hbase.zookeeper.dns.interface</name>
    <value>$iface</value>
  </property>
  <property>
    <name>hbase.regionserver.dns.interface</name>
    <value>$iface</value>
  </property>
  <property>
    <name>hbase.master.dns.interface</name>
    <value>$iface</value>
  </property>
</configuration>
EOF

./bin/start-hbase.sh &
