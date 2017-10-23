#!/usr/bin/env bash

set -e

SCRIPT_BASE_PATH=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
cd "$SCRIPT_BASE_PATH"

###############################################
# Extract Environment Variables from .env file
# Ex. REGISTRY_URL="$(getenv REGISTRY_URL)"
###############################################
getenv(){
    local _env="$(printenv $1)"
    echo "${_env:-$(cat .env | awk 'BEGIN { FS="="; } /^'$1'/ {sub(/\r/,"",$2); print $2;}')}"
}

DOCKER_COMPOSE_VERSION="1.14.0"
CONF_ARG="-f docker-compose-prod-elk.yml"
PATH=$PATH:/usr/local/bin/
REGISTRY_URL="$(getenv REGISTRY_URL)"

########################################
# Install docker-compose
# DOCKER_COMPOSE_VERSION need to be set
########################################
install_docker_compose() {
    sudo curl -L "https://github.com/docker/compose/releases/download/$DOCKER_COMPOSE_VERSION/docker-compose-$(uname -s)-$(uname -m)" \
    -o /usr/local/bin/docker-compose
    sudo chmod +x /usr/local/bin/docker-compose
    return 0
}

if ! command -v docker-compose >/dev/null 2>&1; then
    install_docker_compose || true
elif [[ "$(docker-compose version --short)" != "$DOCKER_COMPOSE_VERSION" ]]; then
    install_docker_compose || true
fi

usage() {
echo "Usage:  $(basename "$0") [MODE] [OPTIONS] [COMMAND]"
echo 
echo "Mode:"
echo "  --prod      ELK Stack for production"
echo "  --dev       ELK Stack for development"
echo
echo "Options:"
echo "  --with-cadv     Add CAdvisor service"
echo "  --with-hub      Add encrypted connection for Kibana, hub required"
echo
echo "Commands:"
echo "  up              Start the services"
echo "  down            Stop the services"
echo "  ps              Show the status of the services"
echo "  logs            Follow the logs on console"
echo "  login           Log in to a Docker registry"
echo "  remove-all      Remove all containers"
echo "  stop-all        Stop all containers running"
echo "  backup          Create a snapshot of the entire cluster"
echo "  delete-old      Remove indices older than # days, see curator action for more details"
echo
}

if [ $# -eq 0 ]; then
    usage
    exit 1
fi

for i in "$@"
do
case $i in
    --prod)
        CONF_ARG="-f docker-compose-prod-elk.yml"
        shift
        ;;
    --dev)
        CONF_ARG="-f docker-compose-dev-elk.yml"
        shift
        ;;
    --with-cadv)
        CONF_ARG="$CONF_ARG -f docker-compose-cadvisor.yml"
        shift
        ;;
    --with-hub)
        CONF_ARG="$CONF_ARG -f docker-compose-with-hub.yml"
        shift
        ;;
    --help|-h)
        usage
        exit 1
        ;;
    *)
        break
        ;;
esac
done

echo "Arguments: $CONF_ARG"
echo "Command: $@"

if [ "$1" == "login" ]; then
    docker login $REGISTRY_URL
    exit 0

elif [ "$1" == "up" ]; then
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
    shift
    docker-compose $CONF_ARG logs -f --tail 200 "$@"
    exit 0

elif [ "$1" == "backup" ]; then
    docker-compose $CONF_ARG -f docker-compose-curator.yml run curator create-snapshot.yml
    docker-compose $CONF_ARG -f docker-compose-curator.yml run curator delete-old-snapshots.yml
    exit 0

elif [ "$1" == "delete-old" ]; then
    docker-compose $CONF_ARG -f docker-compose-curator.yml run curator delete-old-indices.yml
    exit 0

elif [ "$1" == "restore" ]; then
    docker-compose $CONF_ARG -f docker-compose-curator.yml run curator restore-snapshot.yml
    exit 0

fi

docker-compose $CONF_ARG "$@"