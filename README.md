# Docker containers for ELK Stack (Elasticsearch, Logstash and Kibana)

## Preparation

Execute the following command as `root` on the host machine, before using Elasticsearch service:

    # sysctl -w vm.max_map_count=262144