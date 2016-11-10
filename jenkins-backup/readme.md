
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

Build the iamge:

```
$ docker build -t jenkins_backup .
```

Launch `jenkins-backup` container with the following flags:

```
$ docker run --rm --env-file env.txt --volumes-from jenkins_data_1 --name jenkins_backup_1 jenkins_backup
```
The key being the `--volumes-from` flag, this links cvolumes from jenkins_data_1 so that this container can backup the volumes from the linked container. Restore will restore to these volumes as well. 

The contents of `env.txt` are:

```
AZURE_STORAGE_ACCOUNT=<<storage account name>>
AZURE_STORAGE_ACCESS_KEY=<<storage account access key>>
AZURE_container_name=<<Azure container name>>
BACKUP_NAME=<<backup name>>
PATHS_TO_BACKUP=/var/log/jenkins /var/jenkins_home
RESTORE=false
```

To perform a restore launch the container with the RESTORE variable set to true
