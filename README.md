# ELK Stack, Elasticsearch, Logstash, Kibana

The purpose of this set of images is to have one server that handle logs from external web applications,
analyze them, make cool charts, and it is a start point for future development and many more cool things.

- **Elasticsearch** - The container for the log data, all the log is saved on this search engine.
- **Logstash** - Is the log aggregator, it takes log from log shippers and saved it into the search engine.
- **Kibana** - Search and visualize the log on a web interface.
- **CAdvisor** - It is a container status analyzer, where you can monitor the memory usage, cpu usage and other stuff.

### Extra

- **ES Head Plugin** - For managing Elasticsearch engine data
- **Cadvisor** - Monitoring service for Docker containers

## Security Notice!

This Docker image include the X-Pack extension that add authentication agains Elasticsearch engine
and provide secured connection between *Elasticsearch*, *Kibana* and *Logstash*.

The *security* module is the only active module,
*monitoring*, *graph*, *watcher* and *reporting* have been disabled 
(they can be used for free only for a small period).

Please keep in mind that it is really important to change the password of the elk users (default is `changeme`),
refer to [this](https://www.elastic.co/guide/en/x-pack/current/installing-xpack.html) 
and [this](https://www.elastic.co/guide/en/x-pack/current/security-getting-started.html) link 
for getting started with x-pack.


## Configurations available:

- **docker-compose-dev-elk.yml**

  This is for testing the entire *ELK* (Elasticsearch, Logstash and Kibana) stack together with log shippers.
  Images are built and executed.

- **docker-compose-prod-elk.yml**

  Production configuration for the ELK stack.

- **docker-compose-cadvisor.yml**

  Container memory manager. It should be available at port `5602`.


## Requirements

First make sure Docker and Docker Compose are installed on the machine with:

    $ docker -v
    $ docker-compose -v

If they are missing, follow the instructions on the official website (they are not hard really...):

- [Docker CE Install How-to](https://docs.docker.com/engine/installation/)
- [Docker Compose Install How-to](https://docs.docker.com/compose/install/)


## How to use this images


**Use the script `docker-auto.sh` to manage these services!**

    $ ./docker-auto.sh --help

Run in production with:

    $ ./docker-auto.sh --elk-prod up

Observe the log with:

    $ ./docker-auto.sh --elk-prod logs

Shutdown the service with:

    $ ./docker-auto.sh --elk-prod down

Monitor the services:

    $ ./docker-auto.sh --elk-prod ps


> **ELK stack deployment**
> 
> *Elasticsearch* and *Logstash* require a large amount of virtual memory, to resolve this issue,
> execute the following command as `root` on the Docker host machine, before starting the service:
>
>       $ sudo sysctl -w vm.max_map_count=262144

`Kibana` Web Interface is accessible through the port `5601`.


## Settings Up the Environment

The following settings are available:

| Variable     | Description                                                                                | Default           |
|--------------|--------------------------------------------------------------------------------------------|-------------------|
| REGISTRY_URL | This is the docker registry host where to publish the images                               |                   |
| ES_JAVA_OPTS | Elasticsearch Java options                                                                 | -Xmx256m -Xms256m |
| LS_JAVA_OPTS | Logstash Java options                                                                      | -Xmx256m -Xms256m |
| ES_DATA_HOME | Elasticsearch data home directory, it should be changed in production to a local directory | esdata            |
| ES_USER      | Elasticsearch user to use with `x-pack` and security enabled                               |                   |
| ES_PASSWORD  | Elasticsearch user password to use with `x-pack` and security enabled                      |                   |

(\*) *table generated with [tablesgenerator](http://www.tablesgenerator.com/markdown_tables)*