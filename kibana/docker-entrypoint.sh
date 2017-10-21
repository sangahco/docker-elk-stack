#!/bin/sh

set -e

envsubst < "$KB_HOME/config/kibana.template.yml" >> "$KB_HOME/config/kibana.yml"

exec kibana "$@"