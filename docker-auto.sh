#!/usr/bin/env bash

set -e

REGISTRY_URL="$REGISTRY_URL"
if [ -z "$REGISTRY_URL" ]; then
    REGISTRY_URL="$(cat .env | awk 'BEGIN { FS="="; } /^REGISTRY_URL/ {sub(/\r/,"",$2); print $2;}')"
fi

SCRIPT_BASE_PATH=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
cd "$SCRIPT_BASE_PATH"

usage() {
echo "Usage:  $(basename "$0") [MODE] [OPTIONS] [COMMAND]"
echo 
echo "Mode:"
echo "  --elk-prod      ELK Stack for production"
echo "  --elk-dev       ELK Stack for development"
echo "  --log-prod      Log shippers for production"
echo "  --log-dev       Log shippers for development"
echo
echo "Options:"
echo "  --with-cadv     Add CAdvisor service"
echo
echo "Commands:"
echo "  up              Start the services"
echo "  down            Stop the services"
echo "  ps              Show the status of the services"
echo "  logs            Follow the logs on console"
echo "  remove-all      Remove all containers"
echo "  stop-all        Stop all containers running"
echo
}

CONF_ARG="-f docker-compose-prod-elk.yml"

if [ $# -eq 0 ]; then
    usage
    exit 1
fi

for i in "$@"
do
case $i in
    --elk-prod)
        CONF_ARG="-f docker-compose-prod-elk.yml"
        shift
        ;;
    --elk-dev)
        CONF_ARG="-f docker-compose-dev-elk.yml"
        shift
        ;;
    --log-prod)
        CONF_ARG="-f docker-compose-prod-log-shippers.yml"
        shift
        ;;
    --log-dev)
        CONF_ARG="-f docker-compose-dev-log-shippers.yml"
        shift
        ;;
    --with-cadv)
        CONF_ARG="$CONF_ARG -f docker-compose-cadvisor.yml"
        shift
        ;;
    --help|-h)
        usage
        exit 1
        ;;
    *)
        ;;
esac
done

echo "Arguments: $CONF_ARG"
echo "Command: $@"

if [ "$1" == "up" ]; then
    docker-compose $CONF_ARG pull
    docker-compose $CONF_ARG build --pull
    docker-compose $CONF_ARG up -d --remove-orphans
    exit 0

elif [ "$1" == "stop-all" ]; then
    if [ -n "$(docker ps --format {{.ID}})" ]
    then docker stop $(docker ps --format {{.ID}}); fi
    exit 0

elif [ "$1" == "remove-all" ]; then
    if [ -n "$(docker ps -a --format {{.ID}})" ]
    then docker rm $(docker ps -a --format {{.ID}}); fi
    exit 0

elif [ "$1" == "logs" ]; then
    docker-compose $CONF_ARG logs -f --tail 200
    exit 0
fi

docker-compose $CONF_ARG "$@"