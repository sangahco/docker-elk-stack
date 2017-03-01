# ELK&Friends Stack, Elasticsearch, Logstash, Kibana with Filebeat and Logspout shippers

This is a logging service composed by several microservices (some of them not so *micro*):

- **Elasticsearch** - The container for the log data, all the log is saved on this search engine
- **Logstash** - Is the log aggregator, it takes log from log shippers and saved it into the search engine
- **Kibana** - Search and visualize the log on a web interface
- **Logspout** - read the log from Docker containers and send it to Logstash
- **Filebeat** - read the log from log files and send it to Logstash

### Extra

- **ES Head Plugin** - For managing Elasticsearch engine data
- **Cadvisor** - Monitoring service for Docker containers


## Configurations available:

- **docker-compose-dev-elk.yml**

  This is for testing the entire *ELK* (Elasticsearch, Logstash and Kibana) stack together with log shippers.
  Images are built and executed.

- **docker-compose-prod-elk.yml**

  Production configuration for the ELK stack.

- **docker-compose-prod-log-shippers.yml**

  Production configuration for log shippers.
  You should use this on the server where the web application is running, 
  in order to send logs to the ELK stack. `LOGSTASH_HOST` required.

- **docker-compose-dev-log-shippers.yml**

  Same as above but for development purpose and it should run on the ELK server.

- **docker-compose-cadvisor.yml**

  Container memory manager. It should be available at port `5602`.

---

## How to Use


**Use the script `docker-auto.sh` to manage these services!**

    $ ./docker-auto.sh --help


> **ELK stack deployment**
> 
> *Elasticsearch* and *Logstash* require a large amount of virtual memory, to resolve this issue,
> execute the following command as `root` on the Docker host machine, before starting the service:
>
>       $ sudo sysctl -w vm.max_map_count=262144

`Kibana` Web Interface is accessible through the port `5601`.
