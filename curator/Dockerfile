FROM alpine:3.5

MAINTAINER Emanuele Disco <emanuele.disco@gmail.com>

ENV CURATOR_HOME=/usr/share/curator
RUN set -ex && \
    apk add --no-cache --virtual \
      python3 && \
    pip3 install --upgrade pip && \
    pip3 install elasticsearch-curator

COPY ./curator.yml /root/.curator/
WORKDIR $CURATOR_HOME
ENTRYPOINT ["curator"]
CMD ["--help"]