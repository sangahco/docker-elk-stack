FROM docker.elastic.co/logstash/logstash:5.2.1
MAINTAINER Emanuele Disco <emanuele.disco@gmail.com>

ENV LS_VERSION=5.2.1 \
    LS_HOME=/usr/share/logstash \
    DEFAULT_LS_USER=elasticsearch \
    LS_JAVA_OPTS="-Xmx256m -Xms256m"

ADD https://artifacts.elastic.co/downloads/logstash/logstash-5.2.1.tar.gz /tmp/pkg.tar.gz

RUN set -ex && \
    cd /tmp && \
    tar -xvf pkg.tar.gz && \
    mkdir -p /opt && mv elasticsearch-* $LS_HOME && \
    chown -R $DEFAULT_ES_USER: $LS_HOME && \
    rm -rf /tmp/*

ADD pipeline/ $LS_HOME/pipeline/
ADD config/ $LS_HOME/config/

EXPOSE 5000 5043

USER $DEFAULT_ES_USER
WORKDIR $ES_HOME

CMD ["logstash", "-f", "/usr/share/logstash/pipeline/"]
