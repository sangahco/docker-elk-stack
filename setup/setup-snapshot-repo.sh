#!/usr/bin/env bash

curl -XPUT -u elastic 'http://localhost:9200/_snapshot/local' -H 'Content-Type: application/json' -d '{
    "type": "fs",
    "settings": {
        "location": "backup",
        "compress": true
    }
}'
