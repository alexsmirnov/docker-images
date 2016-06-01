#FROM ubuntu:trusty
FROM n3ziniuka5/ubuntu-oracle-jdk:14.04-JDK8

MAINTAINER alexsmirnov 

ENV DSE_VERSION="4.8.8-1" SCALA_VERSION="2.10"
ADD https://debian.datastax.com/debian/repo_key /tmp/dse_key
RUN echo "deb http://alexander.smirnov_mulesoft.com:bYDUKqZc8nQGGE6@debian.datastax.com/enterprise stable main" > /etc/apt/sources.list.d/datastax.sources.list && \
    cat /tmp/dse_key | apt-key add - && \
    apt-get update && \
    apt-get install -y dse-full=${DSE_VERSION} sysstat && rm -rf /var/lib/apt/lists/* 

VOLUME ["/dse"]

COPY conf/cassandra/cassandra.yaml.template /etc/dse/cassandra/
COPY dserun.sh /usr/bin/dserun
ENV MAX_HEAP_SIZE="1G" HEAP_NEWSIZE="400M"

ENTRYPOINT [ "/usr/bin/dserun" ]

EXPOSE 7000 7001 9042 9160 7077 7080 7081 4040 4041 4042 7199

CMD ["cassandra", "-k", "-f"]
