FROM openjdk:8-jre
MAINTAINER Emanuele Disco <emanuele.disco@gmail.com>

ENV LS_VERSION=5.6.13 \
    LS_HOME=/usr/share/logstash \
    DEFAULT_LS_USER=logstash \
    LS_JAVA_OPTS="-Xmx256m -Xms256m" \
    ES_HOST="http://elasticsearch:9200"

RUN set -ex && \
    useradd -ms /bin/bash $DEFAULT_LS_USER && \
    cd /tmp && \
    curl https://s3.ap-northeast-2.amazonaws.com/sangah-b1/logstash-${LS_VERSION}.tar.gz -o /tmp/pkg.tar.gz && \
    tar -xf pkg.tar.gz && \
    mkdir -p $LS_HOME && cp -a logstash-*/. $LS_HOME && \
    chown -R $DEFAULT_LS_USER: $LS_HOME && \
    sed -i -e 's/-Xms/#-Xms/' $LS_HOME/config/jvm.options && \
    sed -i -e 's/-Xmx/#-Xmx/' $LS_HOME/config/jvm.options && \
    rm -rf /tmp/*

ADD pipeline/ $LS_HOME/pipeline/
ADD config/ $LS_HOME/config/

ENV PATH $LS_HOME/bin:$PATH
USER $DEFAULT_LS_USER
WORKDIR $LS_HOME

EXPOSE 5000 5000/udp 5043

CMD ["logstash", "-f", "pipeline"]