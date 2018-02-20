#!/usr/bin/env bash

curl -XPOST -u elastic 'http://localhost:9200/_xpack/security/role/kibana_admin' -H 'Content-Type: application/json' -d '{
  "indices" : [
    {
      "names" : [ "*" ],
      "privileges" : [ "all", "manage", "read", "index" ]
    }
  ]
}'

curl -XPOST -u elastic 'http://localhost:9200/_xpack/security/user/sangah' -H 'Content-Type: application/json' -d '{
  "password" : "tkddkpmisV2",
  "full_name" : "SangAh Admin",
  "email" : "pmis@sangah.com",
  "roles" : [ "kibana_admin", "kibana_user" ]
}'
