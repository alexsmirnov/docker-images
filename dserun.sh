#!/bin/bash
HOSTIP=`hostname -i`
    sed -i "s/broadcast_rpc_address: .*\$/broadcast_rpc_address: ${HOSTIP}/" /etc/dse/cassandra/cassandra.yaml
    sed -i "s/listen_address: .*\$/listen_address: ${HOSTIP}/" /etc/dse/cassandra/cassandra.yaml
if grep -q '\sdseseed\s' /etc/hosts || grep -q '\sdseseed$' /etc/hosts ; then
    echo "linked"
else 
    echo "seed"
    sed -i "s/seeds: .*\$/seeds: ${HOSTIP}/" /etc/dse/cassandra/cassandra.yaml
    echo 'auto_bootstrap: false' >> /etc/dse/cassandra/cassandra.yaml
fi
service datastax-agent start
mkdir -p /dse/spark
exec /usr/bin/dse "$@" 
