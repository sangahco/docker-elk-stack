#!/bin/sh

set -e

envsubst < "$LS_HOME/config/logstash.yml.template" >> "$KB_HOME/config/logstash.yml"

exec logstash -f pipeline "$@"