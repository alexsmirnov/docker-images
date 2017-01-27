FROM alexsmirnov/servers:spark-2.1.0

MAINTAINER alexsmirnov 

ENV zeppelin_ver 0.6.2

RUN curl http://mirrors.ibiblio.org/apache/zeppelin/zeppelin-${zeppelin_ver}/zeppelin-${zeppelin_ver}-bin-netinst.tgz | \
          tar -zx -C /opt \
      && ln -s /opt/zeppelin-${zeppelin_ver}-bin-netinst /opt/zeppelin \
      && ls -la /opt

COPY zeppelin-log4j.properties /opt/zeppelin/conf/log4j.properties
COPY zeppelin-env.sh /opt/zeppelin/conf/zeppelin-env.sh
COPY docker-zeppelin.sh /opt/zeppelin/bin/docker-zeppelin.sh
EXPOSE 8080
ENTRYPOINT ["/opt/zeppelin/bin/docker-zeppelin.sh"]
