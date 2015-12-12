#FROM ubuntu:trusty
FROM n3ziniuka5/ubuntu-oracle-jdk:14.04-JDK8

MAINTAINER alexsmirnov 

ENV KAFKA_VERSION="0.8.2.1" SCALA_VERSION="2.10"

#RUN apt-get update \
      #&& apt-get install -y unzip wget curl \
      #&& apt-get clean \
      #&& rm -rf /var/lib/apt/lists/* 

COPY *.sh /usr/bin/

RUN /usr/bin/download-kafka.sh \
    | tar xzf - -C /opt

VOLUME ["/kafka"]

ENV KAFKA_HOME /opt/kafka_${SCALA_VERSION}-${KAFKA_VERSION}

CMD ["/usr/bin/start-kafka.sh"]

COPY log4j.properties ${KAFKA_HOME}/config/log4j.properties
