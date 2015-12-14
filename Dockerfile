FROM n3ziniuka5/ubuntu-oracle-jdk:14.04-JDK8

MAINTAINER alexsmirnov

ENV ZOOKEEPER_VERSION="3.4.7"

COPY *.sh /usr/bin/

RUN /usr/bin/download-zookeeper.sh \
   | tar -xzf - -C /opt

COPY zoo.cfg /opt/zookeeper-$ZOOKEEPER_VERSION/conf/zoo.cfg

ENV ZK_HOME=/opt/zookeeper-$ZOOKEEPER_VERSION JMXDISABLE=true ZOO_LOG_DIR=/logs

EXPOSE 2181 2888 3888

WORKDIR /opt/zookeeper-$ZOOKEEPER_VERSION

VOLUME ["/data", "/logs"]

ENTRYPOINT ["/opt/zookeeper-3.4.7/bin/zkServer.sh"]

CMD  ["start-foreground"]
