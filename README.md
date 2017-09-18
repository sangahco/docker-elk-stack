# ELK Stack, Elasticsearch, Logstash, Kibana

The purpose of this set of images is to have one server that handle logs from external web applications,
analyze them, make cool charts, and it is a start point for future development and many more cool things.

- **Elasticsearch** - The container for the log data, all the log is saved on this search engine.
- **Logstash** - Is the log aggregator, it takes log from log shippers and saved it into the search engine.
- **Kibana** - Search and visualize the log on a web interface.
- **Curator** - Tool for backup, clean and restore of Elasticsearch indices.
- **CAdvisor** - It is a container status analyzer, where you can monitor the memory usage, cpu usage and other stuff.

### Extra

- **ES Head Plugin** - For managing Elasticsearch engine data
- **Cadvisor** - Monitoring service for Docker containers


## Configurations available:

- **docker-compose-dev-elk.yml**

  This is for testing the entire *ELK* (Elasticsearch, Logstash and Kibana) stack together with log shippers.
  Images are built and executed.

- **docker-compose-prod-elk.yml**

  Production configuration for the ELK stack.

  **docker-compose-with-hub**

  Configuration to use with the [Hub service](https://github.com/sangahco/docker-webapp-hub)

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
> *Elasticsearch* and *Logstash* require a large amount of virtual memory,
> depending on the environment Elasticsearch might not start correctly.
> I prepared a script inside the folder `setup` to run before starting the services, so make sure you run it.
>
>       $ sudo setup/machine-init.sh
>
> Or execute the following command as `root` on the Docker host machine, before starting the service:
>
>       $ sudo sysctl -w vm.max_map_count=262144

`Kibana` Web Interface is accessible through the port `5601`.

***IMPORTANT*** The default user for Kibana is `elastic` and password `changeme`.


## Settings Up the Environment

The following settings are available:

| Variable         | Description                                                                                                                                                                                                                                                                  | Default           |
|------------------|------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|-------------------|
| REGISTRY_URL     | This is the docker registry host where to publish the images                                                                                                                                                                                                                 |                   |
| IMAGE_TAG        | This is the docker image tag, at the moment there are two version: `5.2` and `5.2-xpack`                                                                                                                                                                                     |                   |
| ES_JAVA_OPTS     | Elasticsearch Java options                                                                                                                                                                                                                                                   | -Xmx256m -Xms256m |
| LS_JAVA_OPTS     | Logstash Java options                                                                                                                                                                                                                                                        | -Xmx256m -Xms256m |
| ES_DATA_HOME     | Elasticsearch data home directory, it should be changed in production to a local directory                                                                                                                                                                                   | esdata            |
| ES_BACKUP_HOME   | This is the folder that should be registered as snapshot repository for Elasticsearch data backup. To create a repository on Elasticsearch see [here](https://www.elastic.co/guide/en/elasticsearch/reference/current/modules-snapshots.html#_shared_file_system_repository) |                   |
| ES_USER          | Elasticsearch user to use with `x-pack` and security enabled                                                                                                                                                                                                                 |                   |
| ES_PASSWORD      | Elasticsearch user password to use with `x-pack` and security enabled                                                                                                                                                                                                        |                   |
| ES_HTPASSWD_PATH |  File Path to the file htpasswd for Basic Authentication. Because X-Pack Basic license doesn't provide authentication we have to add basic authentication to Nginx                                                                                                           |                   |


(\*) *table generated with [tablesgenerator](http://www.tablesgenerator.com/markdown_tables)*