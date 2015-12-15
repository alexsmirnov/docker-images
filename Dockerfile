FROM ubuntu:trusty

MAINTAINER alexsmirnov 

ADD https://debian.datastax.com/debian/repo_key /tmp/dse_key
RUN echo "deb http://alexander.smirnov_mulesoft.com:bYDUKqZc8nQGGE6@debian.datastax.com/enterprise stable main" > /etc/apt/sources.list.d/datastax.sources.list && \
    cat /tmp/dse_key | apt-key add - && \
    apt-get update && \
    apt-get install -y opscenter && rm -rf /var/lib/apt/lists/* 



EXPOSE 8888 50031 61620

VOLUME ["/var/run/opscenter"]

ENTRYPOINT ["/usr/share/opscenter/bin/opscenter","-f"]

