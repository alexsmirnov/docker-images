#!/bin/bash
. /opt/spark/bin/start-common.sh

echo "$(hostname -i) spark-master" >> /etc/hosts

# Run spark-class directly so that when it exits (or crashes), the pod restarts.
exec /opt/spark/bin/spark-class org.apache.spark.deploy.master.Master --ip spark-master --port 7077 --webui-port 8080 "$@"
