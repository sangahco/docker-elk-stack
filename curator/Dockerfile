FROM alpine:3.5

MAINTAINER Emanuele Disco <emanuele.disco@gmail.com>

ENV CURATOR_HOME=/usr/share/curator \
    ES_HOST=127.0.0.1 \
    ES_PORT=9200 \
    CURATOR_USE_SSL=False \
    CURATOR_SSL_NO_VALIDATE=False

WORKDIR $CURATOR_HOME
COPY ./requirements.txt ${CURATOR_HOME}
RUN set -ex && \
    apk add --no-cache --virtual \
      python3 && \
    pip3 install --upgrade pip && \
    pip3 install -r requirements.txt && \
    pip3 install elasticsearch-curator==5.6

COPY ./curator.yml /root/.curator/
ENTRYPOINT ["curator"]
CMD ["--help"]