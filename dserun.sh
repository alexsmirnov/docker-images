#!/bin/bash
set -e
export HOSTIP=$(hostname -i)
export SEEDS=${SEEDS:-"$HOSTIP"}
export AUTO_BOOTSTRAP=${AUTO_BOOTSTRAP:-"true"}
export BROADCAST_ADDRESS=${BROADCAST_ADDRESS:-"$HOSTIP"}
export LISTEN_ADDRESS=${LISTEN_ADDRESS:-"$HOSTIP"}
export CLUSTER=${CLUSTER:-"docker"}
env

sed -e "s/_SEEDS_/${SEEDS}/" \
 -e "s/_AUTO_BOOTSTRAP_/${AUTO_BOOTSTRAP}/" \
 -e "s/_BROADCAST_ADDRESS_/${BROADCAST_ADDRESS}/" \
 -e "s/_LISTEN_ADDRESS_/${LISTEN_ADDRESS}/" \
 -e "s/_CLUSTER_/${CLUSTER}/" \
 /etc/dse/cassandra/cassandra.yaml.template > /etc/dse/cassandra/cassandra.yaml

if [[ -n "${OPSCENTER}" ]] ; then
  echo "stomp_interface: \"${OPSCENTER}\"" > /var/lib/datastax-agent/conf/address.yaml
  service datastax-agent start
fi
mkdir -p /dse/spark
exec /usr/bin/dse "$@" 
