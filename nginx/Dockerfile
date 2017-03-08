FROM nginx:alpine

COPY ./conf.d/ /etc/nginx/conf.d/
COPY ./stream/ /usr/share/nginx/stream/
COPY ./nginx.conf.template /etc/nginx/

EXPOSE 80 443 5601 9200 5000 5000/udp 5043

COPY ./docker-entrypoint.sh ./entrypoint.sh
RUN chmod +x /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]