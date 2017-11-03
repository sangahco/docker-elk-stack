[![HitCount](http://hits.dwyl.io/sangahco/sangahco/docker-elk-stack.svg)](http://hits.dwyl.io/sangahco/sangahco/docker-elk-stack)

[![Jenkins](https://img.shields.io/jenkins/s/https/dev.builder.sangah.com/job/elk-5.4.svg?label=5.4&style=flat-square)]()
[![Jenkins](https://img.shields.io/jenkins/s/https/dev.builder.sangah.com/job/elk-xpack-5.4.svg?label=5.4-xpack&style=flat-square)]()

[![Jenkins](https://img.shields.io/jenkins/s/https/dev.builder.sangah.com/job/elk-5.2.svg?label=5.2&style=flat-square)]()
[![Jenkins](https://img.shields.io/jenkins/s/https/dev.builder.sangah.com/job/elk-xpack-5.2.svg?label=5.2-xpack&style=flat-square)]()

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


> ### In order to use TLS configuration we need to provide valid **certificate** and **key**.
>
> Prepare a folder with the following files:
> - `server-cert.pem`
> - `server-key.pem`
> - `ca.pem`
>
> than change the variable `SSL_DIR` inside the file `.env` to the location of this folder.


## Configurations available:

- **docker-compose-dev-elk.yml**

  For development purpose build and run Elasticsearch, Kibana and Logstash.
  
  Use together with `docker-compose-with-tls.yml` to use TLS connection.
  
  Use together with `docker-compose-with-notls.yml` to use simple TCP connection.

        INTERNET <----TLS/TCP----> ES
        INTERNET <----HTTP(S)----> ES
        INTERNET <----HTTP----> KIBANA
        INTERNET <----TLS/TCP----> LOGSTASH

---

- **docker-compose-prod-elk.yml**

  Production configuration for the ELK stack.
  Same as above but will use built images.

  Use together with `docker-compose-with-tls.yml` to use TLS connection.
  
  Use together with `docker-compose-with-notls.yml` to use simple TCP connection.

        INTERNET <----TLS/TCP----> ES
        INTERNET <----HTTP(S)----> ES
        INTERNET <----HTTP----> KIBANA
        INTERNET <----TLS/TCP----> LOGSTASH


---

- **docker-compose-dev-es.yml**

  Add an Elasticsearch node to the cluster!
  This configuration launch an Elasticsearch node ready to communicate with TLS connection.
  In order to use this configuration we need to provide valid **ssl certificate** and **key**.

        ES1      <----TLS----> ES2
        INTERNET <----TLS----> ES

---

- **docker-compose-dev-es-notls.yml**

  Add an Elasticsearch node to the cluster!
  This is the plain TCP configuration, no encryption, it means that the Elasticsearch nodes will talk with plain TCP.
  If the cluster is running with TLS we need to use `docker-compose-dev-es.yml` instead.

        ES1      <----TCP----> ES2
        INTERNET <----TCP----> ES

  First thing to do is change the variable `ES_MINIMUM_MASTER_NODE` accordingly, 
  it is really important to set it correctly to run a cluster, by default is set to have 2 master nodes.
  If you try to start one node it will standby looking for another master, this is the wanted behaviour.
  As soon as you start another node you will see they join together!

  In order to use this configuration first build the image:

      $ docker-compose -f docker-compose-dev-es-notls.yml build

  Than we launch one node with the following command:

      $ ES_TRANSPORT_PORT=9300 docker-compose -f docker-compose-dev-es-notls.yml -p node1 up

  If we want to add another node to the cluster:
    
      $ ES_TRANSPORT_PORT=9301 docker-compose -f docker-compose-dev-es-notls.yml -p node2 up

---

- **docker-compose-prod-es.yml**
  
  Add an Elasticsearch node to the cluster!
  Connection is encrypted using TLS protocol.

          ES1      <----TLS----> ES2
          INTERNET <----TLS----> ES

  For how to use it just see above.

---

- **docker-compose-with-tls.yml**

  With this option we add TLS connection (encryption) between Internet and our services.
  (**Kibana excluded use the hub for the same purpose**).
  Nginx is used to add encryption from the outside, inside, plain TCP connection is used.
  
        INTERNET <----TLS/HTTPS----> ES
        INTERNET <----TLS----> LOGSTASH
        INTERNET <----HTTP----> KIBANA

        ES <----HTTP----> KIBANA
        ES <----HTTP----> LOGSTASH

---

- **docker-compose-with-notls.yml**

  This configuration should be use only for testing since the connection is plain TCP and HTTP.

        INTERNET <----TCP/HTTP----> ES
        INTERNET <----TCP----> LOGSTASH
        INTERNET <----HTTP----> KIBANA

        ES <----HTTP----> KIBANA
        ES <----HTTP----> LOGSTASH

---

- **docker-compose-with-hub**

  This option add TLS connection for Kibana.
  Configuration to use with the [Hub service](https://github.com/sangahco/docker-webapp-hub)

        INTERNET <----HTTPS----> KIBANA

---

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


> ***IMPORTANT***
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


> ***IMPORTANT*** 
>
> `Kibana` Web Interface is accessible through the port `5601`.


> ***IMPORTANT*** 
> 
> The default user for `Kibana` is `elastic` and password `changeme`.


> **The Cluster will not work if the following condition are verified:**
> - We are using `docker-compose-with-tls.yml`
> - We are NOT using X-Pack
> This is due to the image configuration, can't do much about it.



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
