# Curator - Guide

Before starting using Curator, some actions are required.

## Preparation

A valid [Shared File System Repository](https://www.elastic.co/guide/en/elasticsearch/reference/current/modules-snapshots.html#_shared_file_system_repository) need to be created.

I already set the `path.repo` variable to `/usr/share/elasticsearch/backups` under the elasticsearch configuration.
We need to register a repository in order to create snapshots.

The following command will register the repository named `local` having relative location `backup`.
The location is relative to the `path.repo` location.

    $ curl -XGET -u sangah --insecure 'https://localhost:9200/_snapshot/local' -H 'Content-Type: application/json' -d '{
        "type": "fs",
        "settings": {
            "location": "backup",
            "compress": true
        }
    }'

The repository name can be different but make sure you send the correct name to the Curator container
using the environment variable `SNAPSHOT_REPOSITORY`.

Check if the repository has been registered correctly with:

    curl -XGET -u sangah --insecure 'https://localhost:9200/_cat/repositories?v

    id      type
    local   fs

## Run

You can run the actions with the following commands:

    $ docker-compose -f docker-compose-prod-elk.yml -f docker-compose-curator.yml run curator create-snapshot.yml
    $ docker-compose -f docker-compose-prod-elk.yml -f docker-compose-curator.yml run curator delete-old-snapshots.yml
    $ docker-compose -f docker-compose-prod-elk.yml -f docker-compose-curator.yml run curator delete-old-indices.yml
    $ docker-compose -f docker-compose-prod-elk.yml -f docker-compose-curator.yml run curator restore-snapshot.yml

Or you can use `docker-auto.sh`:

Backup and delete old snapshot

    $ ./docker-auto.sh backup

Delete old indices

    $ ./docker-auto.sh delete-old

Restore snapshot

    $ ./docker-auto.sh restore


You can check the list of snapshots available using the following request:

    curl -XGET -u sangah --insecure 'https://localhost:9200/_cat/snapshots/backups?v'


You can have full information for a snapshot with the following request, just change the last part with the correct snapshot name:

    curl -XGET -u sangah --insecure 'https://localhost:9200/_snapshot/backups/curator-20170717110004?pretty'


## Settings Up the Environment

The following settings are available:

| Variable                        | Description                                                                               | Default   |
|---------------------------------|-------------------------------------------------------------------------------------------|-----------|
| SNAPSHOT_REPOSITORY             | The name of the repository.                                                               | backups   |
| SNAPSHOT_NAME                   | leave blank and will be auto generated (curator-20170717110004).                          |           |
| SNAPSHOT_INDEX_PREFIX           | It should not be required but if you changed logstash prefix you need to change this too. | logstash- |
| SNAPSHOT_INDEX_RETENTION_PERIOD | logstash data older than this period in days will be deleted.                             | 90        |
| SNAPSHOT_RETENTION_PERIOD       | snapshots older than this period in days will be deleted.                                 | 3         |