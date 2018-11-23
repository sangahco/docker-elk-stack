FROM openjdk:8-jre
MAINTAINER Emanuele Disco <emanuele.disco@gmail.com>

ENV KB_HOME=/opt/kibana \
    DEFAULT_KB_USER=kibana \
    KIBANA_VERSION=5.6.13 \
    NODE_TLS_REJECT_UNAUTHORIZED=0 \
    ES_HOST="http://elasticsearch:9200"

COPY ./*.yml /tmp/config/

RUN set -ex && \
    apt-get update && apt-get -y install \
      gettext-base && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

RUN set -ex && \
    useradd -ms /bin/bash $DEFAULT_KB_USER && \
    cd /tmp && \
    curl https://s3.ap-northeast-2.amazonaws.com/sangah-b1/kibana-${KIBANA_VERSION}-linux-x86_64.tar.gz -o pkg.tar.gz && \
    tar -xf pkg.tar.gz && \
    mkdir -p $KB_HOME && cp -a kibana-*/. $KB_HOME && \
    mkdir -p $KB_HOME/config && cp /tmp/config/* $KB_HOME/config/ && \
    chown -R $DEFAULT_KB_USER: $KB_HOME && \
    rm -rf /tmp/*

ENV PATH $KB_HOME/bin:$PATH

COPY ./docker-entrypoint.sh /entrypoint.sh
RUN chmod a+x /entrypoint.sh

EXPOSE 5601

VOLUME $KB_HOME/data
WORKDIR $KB_HOME
USER $DEFAULT_KB_USER
ENTRYPOINT ["/entrypoint.sh"]