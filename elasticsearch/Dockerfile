FROM openjdk:8-jre
MAINTAINER Emanuele Disco <emanuele.disco@gmail.com>

ENV ES_VERSION=5.2.0 \
    ES_HOME=/opt/elasticsearch \
    DEFAULT_ES_USER=elasticsearch \
    ES_JAVA_OPTS="-Xmx256m -Xms256m"

RUN useradd -ms /bin/bash $DEFAULT_ES_USER

#ADD https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-${ES_VERSION}.tar.gz /tmp/pkg.tar.gz
RUN set -ex && \
    cd /tmp && \
    curl https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-${ES_VERSION}.tar.gz -o pkg.tar.gz && \
    tar -xvf pkg.tar.gz && \
    mkdir -p /opt && mv elasticsearch-* $ES_HOME && \
    chown -R $DEFAULT_ES_USER: $ES_HOME/config && \
    mkdir $ES_HOME/data && chown -R $DEFAULT_ES_USER: $ES_HOME/data && \
    mkdir $ES_HOME/logs && chown -R $DEFAULT_ES_USER: $ES_HOME/logs && \
    sed -i -e 's/-Xms/#-Xms/' $ES_HOME/config/jvm.options && \
    sed -i -e 's/-Xmx/#-Xmx/' $ES_HOME/config/jvm.options && \
    rm -rf /tmp/*

COPY ./config/elasticsearch.yml $ES_HOME/config/

HEALTHCHECK --interval=60s CMD curl --fail http://localhost:9200/_cat/health || exit 1

EXPOSE 9200 9300

USER $DEFAULT_ES_USER
WORKDIR $ES_HOME
VOLUME $ES_HOME/data
ENTRYPOINT ["/opt/elasticsearch/bin/elasticsearch"]