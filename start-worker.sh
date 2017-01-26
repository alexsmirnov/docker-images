#!/bin/bash
. /opt/spark/bin/start-common.sh

# Run spark-class directly so that when it exits (or crashes), the pod restarts.
exec /opt/spark/bin/spark-class org.apache.spark.deploy.worker.Worker spark://spark-master:7077 --webui-port 8081 "$@"
