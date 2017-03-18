FROM openjdk:8-jre
MAINTAINER Emanuele Disco <emanuele.disco@gmail.com>

ENV ES_VERSION=5.2.1 \
    ES_HOME=/usr/share/elasticsearch \
    DEFAULT_ES_USER=elasticsearch \
    ES_JAVA_OPTS="-Xmx256m -Xms256m"

RUN set -ex && \
    useradd -ms /bin/bash $DEFAULT_ES_USER && \
    cd /tmp && \
    curl https://s3.ap-northeast-2.amazonaws.com/sangah-b1/elasticsearch-${ES_VERSION}.tar.gz -o pkg.tar.gz && \
    tar -xf pkg.tar.gz && \
    mkdir -p $ES_HOME && cp -a elasticsearch-*/. $ES_HOME && \
    chown -R $DEFAULT_ES_USER: $ES_HOME/config && \
    mkdir $ES_HOME/data && \
    mkdir $ES_HOME/logs && \
    chown -R $DEFAULT_ES_USER: $ES_HOME && \
    sed -i -e 's/-Xms/#-Xms/' $ES_HOME/config/jvm.options && \
    sed -i -e 's/-Xmx/#-Xmx/' $ES_HOME/config/jvm.options && \
    rm -rf /tmp/*

COPY ./config $ES_HOME/config

HEALTHCHECK --interval=60s CMD curl --fail http://localhost:9200/_cat/health || exit 1

ENV PATH $ES_HOME/bin:$PATH

EXPOSE 9200 9300

USER $DEFAULT_ES_USER
WORKDIR $ES_HOME
VOLUME $ES_HOME/data
ENTRYPOINT ["elasticsearch"]