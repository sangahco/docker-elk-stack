#!/bin/sh

set -e

envsubst < "$LS_HOME/config/logstash.yml.template" >> "$LS_HOME/config/logstash.yml"

exec logstash -f pipeline "$@"