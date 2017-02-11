FROM logstash:5.2.0
MAINTAINER Emanuele Disco <emanuele.disco@gmail.com>

RUN rm -f /usr/share/logstash/pipeline/logstash.conf
ADD pipeline/ /usr/share/logstash/pipeline/
ADD config/ /usr/share/logstash/config/

CMD ["-f", "/usr/share/logstash/pipeline/logstash.conf"]