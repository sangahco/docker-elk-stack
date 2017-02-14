# ELK&Friends Stack, Elasticsearch, Logstash, Kibana with Filebeat and Logspout shippers

This is a logging service composed by several microservices:

- **Elasticsearch** - The container for the log data, all the log is saved on this search engine
- **Logstash** - Is the log aggregator, it takes log from log shippers and saved it into the search engine
- **Kibana** - Search and visualize the log on a web interface
- **Logspout** - read the log from Docker containers and send it to Logstash
- **Filebeat** - read the log from log files and send it to Logstash

### Extra

- **ES Head Plugin** - For managing Elasticsearch engine data
- **Cadvisor** - Monitoring service for Docker containers

> Before anything else execute the following command as `root` on the Docker host machine, before starting the service:
>
>       $ sudo sysctl -w vm.max_map_count=262144

Start the service with the following command:

    $ docker-compose up -d

Stop with:

    $ docker-compose down

Update the services and run with:

    $ docker-compose up -d --build

## How to Use

`Kibana` Web Interface is accessible through the port *5601*
