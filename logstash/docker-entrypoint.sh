#!/bin/sh

set -e

mv $LS_HOME/config/logstash.yml $LS_HOME/config/logstash.template.yml
envsubst < "$LS_HOME/config/logstash.template.yml" >> "$LS_HOME/config/logstash.yml"

exec logstash -f pipeline "$@"