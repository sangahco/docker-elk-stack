FROM openjdk:8-jre
MAINTAINER Emanuele Disco <emanuele.disco@gmail.com>

ENV KB_HOME=/opt/kibana \
    DEFAULT_KB_USER=kibana \
    KIBANA_VERSION=5.4.3

RUN set -ex && \
    useradd -ms /bin/bash $DEFAULT_KB_USER && \
    cd /tmp && \
    curl https://s3.ap-northeast-2.amazonaws.com/sangah-b1/kibana-${KIBANA_VERSION}-linux-x86_64.tar.gz -o pkg.tar.gz && \
    tar -xf pkg.tar.gz && \
    mkdir -p $KB_HOME && cp -a kibana-*/. $KB_HOME && \
    chown -R $DEFAULT_KB_USER: $KB_HOME && \
    rm -rf /tmp/*

COPY ./kibana.yml $KB_HOME/config/

ENV PATH $KB_HOME/bin:$PATH

EXPOSE 5601

VOLUME $KB_HOME/data
WORKDIR $KB_HOME
USER $DEFAULT_KB_USER
ENTRYPOINT ["kibana"]