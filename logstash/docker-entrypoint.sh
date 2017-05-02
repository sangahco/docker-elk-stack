#!/bin/sh

set -e

envsubst < "$LS_HOME/config/logstash.template.yml" >> "$LS_HOME/config/logstash.yml"

exec logstash -f pipeline "$@"