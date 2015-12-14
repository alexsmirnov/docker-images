FROM java:7

MAINTAINER alexsmirnov

ENV ZOOKEEPER_VERSION=3.4.7
COPY download-zookeeper.sh /usr/bin
RUN /usr/bin/download-zookeeper.sh \
   | tar -xzf - -C /opt

COPY zoo.cfg /opt/zookeeper-${ZOOKEEPER_VERSION}/conf/zoo.cfg

ENV ZK_HOME=/opt/zookeeper-${ZOOKEEPER_VERSION} JMXDISABLE=true ZOO_LOG_DIR=/logs

EXPOSE 2181 2888 3888

WORKDIR /opt/zookeeper-${ZOOKEEPER_VERSION}

VOLUME ["/data", "/logs"]

ENTRYPOINT ["/opt/zookeeper-${ZOOKEEPER_VERSION}/bin/zkServer.sh"]

CMD  ["start-foreground"]
