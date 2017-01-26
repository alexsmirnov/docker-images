FROM n3ziniuka5/ubuntu-oracle-jdk:14.04-JDK8

MAINTAINER alexsmirnov 

ENV hadoop_ver_major 2.7
ENV hadoop_ver_minor 3
ENV hadoop_ver "${hadoop_ver_major}.${hadoop_ver_minor}"
ENV spark_ver 2.1.0


RUN apt-get update \
      && apt-get install -y curl python-numpy \
      && mkdir -p /opt \
      && curl http://mirrors.ibiblio.org/apache/hadoop/common/hadoop-${hadoop_ver}/hadoop-${hadoop_ver}.tar.gz | \
          tar -zx -C /opt hadoop-${hadoop_ver}/lib/native \
      && curl http://mirrors.ibiblio.org/apache/spark/spark-${spark_ver}/spark-${spark_ver}-bin-hadoop${hadoop_ver_major}.tgz | \
          tar -zx -C /opt \
      && ln -s /opt/spark-${spark_ver}-bin-hadoop${hadoop_ver_major} /opt/spark \
      && ln -s /opt/hadoop-${hadoop_ver} /opt/hadoop \
      && apt-get clean \
      && rm -rf /var/lib/apt/lists/* 

COPY *.sh /opt/spark/bin/

COPY conf/* /opt/spark/conf/
ENV PATH $PATH:/opt/spark/bin
