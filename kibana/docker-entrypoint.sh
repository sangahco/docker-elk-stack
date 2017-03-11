#!/bin/sh

set -e

envsubst < "$KB_HOME/config/kibana.yml.template" >> "$KB_HOME/config/kibana.yml"

exec kibana "$@"