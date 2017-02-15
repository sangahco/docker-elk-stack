FROM docker.elastic.co/logstash/logstash:5.2.1
MAINTAINER Emanuele Disco <emanuele.disco@gmail.com>

ARG LS_HOME=/usr/share/logstash

RUN set -ex && \
  rm -f $LS_HOME/pipeline/logstash.conf && \
  sed -i -e 's/-Xms/#-Xms/' $LS_HOME/config/jvm.options && \
  sed -i -e 's/-Xmx/#-Xmx/' $LS_HOME/config/jvm.options

ADD pipeline/ $LS_HOME/pipeline/
ADD config/ $LS_HOME/config/

EXPOSE 5000 5043