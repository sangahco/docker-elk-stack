FROM openjdk:8-jre
MAINTAINER Emanuele Disco <emanuele.disco@gmail.com>

ENV KB_HOME=/opt/kibana \
    DEFAULT_KB_USER=kibana \
    KIBANA_VERSION=5.2.1 \
    NODE_TLS_REJECT_UNAUTHORIZED=0

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
    curl https://s3.ap-northeast-2.amazonaws.com/sangah-b1/x-pack-${KIBANA_VERSION}.zip -o x-pack.zip && \
    cd $KB_HOME && bin/kibana-plugin install file:///tmp/x-pack.zip && \
    rm -rf /tmp/*

COPY ./kibana.yml $KB_HOME/config/
COPY ./kibana.yml.template $KB_HOME/config/

RUN chown -R $DEFAULT_KB_USER: $KB_HOME

ENV PATH $KB_HOME/bin:$PATH

COPY ./docker-entrypoint.sh /entrypoint.sh
RUN chmod a+x /entrypoint.sh

EXPOSE 5601

VOLUME $KB_HOME/data
WORKDIR $KB_HOME
USER $DEFAULT_KB_USER
ENTRYPOINT ["/entrypoint.sh"]