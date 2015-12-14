#!/bin/sh 
set -e
mirror=$(wget -nv -O -  https://www.apache.org/dyn/closer.cgi\?as_json\=1 | sed -rn 's/.*"preferred":.*"(.*)"/\1/p')
url="${mirror}zookeeper/zookeeper-${ZOOKEEPER_VERSION}/zookeeper-${ZOOKEEPER_VERSION}.tar.gz"
wget -nv "${url}" -O -
