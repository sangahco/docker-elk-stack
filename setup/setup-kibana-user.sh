#!/usr/bin/env bash

curl -XPOST -u elastic 'http://localhost:9200/_xpack/security/role/kibana_reader' -H 'Content-Type: application/json' -d '{
  "cluster": [],
  "indices": [
    {
      "names": [
        "*"
      ],
      "privileges": [
        "read",
        "view_index_metadata"
      ]
    }
  ],
  "run_as": [],
  "metadata": {},
  "transient_metadata": {
    "enabled": true
  }
}'

curl -XPOST -u elastic 'http://localhost:9200/_xpack/security/user/sangah' -H 'Content-Type: application/json' -d '{
  "password" : "tkddkpmisV2",
  "full_name" : "SangAh Admin",
  "email" : "pmis@sangah.com",
  "roles" : [ "kibana_reader", "kibana_user", "reporting_user" ]
}'
