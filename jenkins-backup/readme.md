
# Jenkins Data Volume Backup

Docker image to backup your Docker container volumes

# Usage

You have a container running with one or more volumes:

From executing a `$ docker inspect jenkin_data_1` we see that this container has two volumes:

```
"Volumes": {
                "/var/jenkins_home": {},
                "/var/log/jenkins": {}
            },
```

Launch `jenkins-backup` container with the following flags:

```
$ docker run --rm \
--env-file env.txt \
--volumes-from jenkins_data_1 \
--name dockup .
```

The contents of `env.txt` being:

```
AZURE_STORAGE_ACCOUNT=<<storage account name>>
AZURE_STORAGE_ACCESS_KEY=<<storage account access key>>
AZURE_container_name=<<Azure container name>>
BACKUP_NAME=<<backup name>>
PATHS_TO_BACKUP=/var/log/jenkins /var/jenkins_home
RESTORE=false
```

To perform a restore launch the container with the RESTORE variable set to true
