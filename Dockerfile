FROM java:7

MAINTAINER alexsmirnov

RUN wget -q -O - http://mirror.vorboss.net/apache/zookeeper/zookeeper-3.4.6/zookeeper-3.4.6.tar.gz | tar -xzf - -C /opt

COPY zoo.cfg /opt/zookeeper-3.4.6/conf/zoo.cfg

ENV ZK_HOME=/opt/zookeeper-3.4.6 JMXDISABLE=true ZOO_LOG_DIR=/logs

EXPOSE 2181 2888 3888

WORKDIR /opt/zookeeper-3.4.6

VOLUME ["/data", "/logs"]

ENTRYPOINT ["/opt/zookeeper-3.4.6/bin/zkServer.sh"]

CMD  ["start-foreground"]
