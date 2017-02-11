FROM openjdk:8-jre
MAINTAINER Emanuele Disco <emanuele.disco@gmail.com>

RUN set -ex && \
    cd /tmp && \
    curl https://artifacts.elastic.co/downloads/kibana/kibana-5.2.0-linux-x86_64.tar.gz -o pkg.tar.gz && \
    tar -xvf pkg.tar.gz && \
    mkdir -p /opt && mv kibana-* /opt/kibana && \
    rm -rf /tmp/*

COPY ./kibana.yml /opt/kibana/config/

ENV ES_HOME=/opt/kibana \
    DEFAULT_ES_USER=kibana

RUN useradd -ms /bin/bash $DEFAULT_ES_USER
WORKDIR $ES_HOME

EXPOSE 5601

VOLUME /opt/kibana/data

USER $DEFAULT_ES_USER
CMD ["/opt/kibana/bin/kibana"]