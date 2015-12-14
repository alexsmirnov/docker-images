#!/bin/bash
# DOCKER_URL=`echo "$DOCKER_HOST" | sed "s/tcp:/https:/"`
# curl --insecure --cert /etc/docker_certs/cert.pem --key /etc/docker_certs/key.pem $DOCKER_URL/containers/json
if [[ -z "$KAFKA_ADVERTISED_HOST_NAME" ]]; then
    export KAFKA_ADVERTISED_HOST_NAME=$(hostname -i)
fi
if [[ -z "$KAFKA_ADVERTISED_PORT" ]]; then
    export KAFKA_ADVERTISED_PORT="9092"
fi
if [[ -z "$KAFKA_BROKER_ID" ]]; then
    export KAFKA_BROKER_ID="1"
fi
if [[ -z "$KAFKA_LOG_DIRS" ]]; then
    export KAFKA_LOG_DIRS="/kafka/kafka-logs-$KAFKA_BROKER_ID"
fi
if [[ -z "$KAFKA_ZOOKEEPER_CONNECT" ]]; then
    export KAFKA_ZOOKEEPER_CONNECT="zookeeper:2181"
fi

if [[ -n "$KAFKA_HEAP_OPTS" ]]; then
    sed -r -i "s/^(export KAFKA_HEAP_OPTS)=\"(.*)\"/\1=\"$KAFKA_HEAP_OPTS\"/g" $KAFKA_HOME/bin/kafka-server-start.sh
    unset KAFKA_HEAP_OPTS
fi

for VAR in `env`
do
  if [[ $VAR =~ ^KAFKA_ && ! $VAR =~ ^KAFKA_HOME ]]; then
    kafka_name=`echo "$VAR" | sed -r "s/KAFKA_(.*)=.*/\1/g" | tr '[:upper:]' '[:lower:]' | tr _ .`
    env_var=`echo "$VAR" | sed -r "s/(.*)=.*/\1/g"`
    if egrep -q "(^|^#)$kafka_name=" $KAFKA_HOME/config/server.properties; then
        sed -r -i "s@(^|^#)($kafka_name)=(.*)@\2=${!env_var}@g" $KAFKA_HOME/config/server.properties #note that no config values may contain an '@' char
    else
        echo "$kafka_name=${!env_var}" >> $KAFKA_HOME/config/server.properties
    fi
  fi
done


$KAFKA_HOME/bin/kafka-server-start.sh $KAFKA_HOME/config/server.properties &
KAFKA_SERVER_PID=$!

function stop_kafka() {
 trap - EXIT
 echo "Killing kafka daemon pid=$1"
 kill -TERM ${1}
 exit
}
trap "stop_kafka ${KAFKA_SERVER_PID}" SIGHUP SIGINT SIGTERM EXIT
while netstat -lnt | awk '$4 ~ /:9092$/ {exit 1}'; do sleep 1; done

if [[ -n $KAFKA_CREATE_TOPICS ]]; then
    IFS=','; for topicToCreate in $KAFKA_CREATE_TOPICS; do
        IFS=':' read -a topicConfig <<< "$topicToCreate"
        $KAFKA_HOME/bin/kafka-topics.sh --create --zookeeper $KAFKA_ZOOKEEPER_CONNECT --replication-factor ${topicConfig[2]} --partition ${topicConfig[1]} --topic "${topicConfig[0]}"
    done
fi

wait $KAFKA_SERVER_PID
