#!/bin/bash

########################################################
#### Change the following to customize your install ####
########################################################

#this will be the name of the resource group and the VM + all other compoents will use this as the base of their names
baseName="abs" 

# for testing and rapidly creating multiple versions for tutorials or testing. Script will create something like dockerBuild01 <- given a suffix of 01 and a baseName of dockerBuild
versionSuffix="" 

#Your Azure account name.
azureAccountName="Visual Studio Enterprise"

#VM Admin user information
username="absadmin"

#custom dns name
customDnsBase="harebrained-apps.com"

########################################################
#### The remainder can be changed but not required  ####
########################################################

#dns names and storage account names can't have upppercase letters
baseNameLower=$(echo "$baseName" | tr '[:upper:]' '[:lower:]')

echo "=> basenamelower <="
echo $baseNameLower

#Resource group info
rgName="$baseName$versionSuffix"

# Set variables for storage
stdStorageAccountName="${baseNameLower}storage$versionSuffix"

#VM Admin user information
adminKeyPairName="id_${vmName}_rsa"

#DNS Naming
dnsName="${baseNameLower}system$versionSuffix"
fullDnsName="${dnsName}.${location}.cloudapp.azure.com"
customDnsName="${baseNameLower}.$customDnsBase"

#Location of remote Docker Host TLS certs
tlsCertLocation="./certs/$rgName"
rsaKeysLocation="./keys/$rgName"

SCRIPTS_LOCATION=$PWD

########################################################
#### The script actually begins...                  ####
########################################################

#TODO: the docker running/stopped/non-existant code could use updating
RUNNING=$(docker inspect --format="{{ .State.Running }}" azureCli 2> /dev/null)

if [ $? -eq 1 ]; then
  	echo "azureCli container does not exist. Executing docker run"
	docker run -td --name azureCli -v $SCRIPTS_LOCATION:/config microsoft/azure-cli
	
	docker exec -it azureCli azure login  
fi

if [ "$RUNNING" == "false" ]; then
  	echo "azureCli is not running. Executing docker start"
      #should START here
	docker start azureCli
	
	docker exec -it azureCli azure login  
fi

docker exec -it azureCli azure account set "$azureAccountName"

set -xe

printf "=> Backing up data volumes locally <="
	
## Backing up Jenkins Data volume 
md backups99

### Backup volumes
docker run --rm --volumes-from jenkins_data_1 -v $(pwd)/backups99:/backup ubuntu tar cvf /backup/${baseNameLower}-home-$(date +"%Y-%m-%d")99.tar /var/jenkins_home

docker run --rm --volumes-from jenkins_data_1 -v $(pwd)/backups99:/backup ubuntu tar cvf /backup/${baseNameLower}-log-$(date +"%Y-%m-%d")99.tar /var/log/jenkins

# ### Copy backups to Azure

# Azure Portal - create storage container (or CLI)

# >SSH into VM 

# docker run -td --name azureCli -v $(pwd)/backups:/backups microsoft/azure-cli

# docker exec -it azureCli azure login
# 	(follow prompts to login)
# docker exec -it azureCli azure account set 'Visual Studio Enterprise'

# docker exec -it azureCli azure storage blob upload --account-name absregistry --account-key 'EvO7CQs3lobGmBN2EQ5HXXZQ+mbEbaB4cU2nR9lZfyCDeIOBAqOxvcZtI9ZXTUyMu+vd5Mngs+k9p6cJQ09QLA==' /backups/log-$(date +"%Y-%m-%d").tar jenkinsdatabackups log-$(date +"%Y-%m-%d").tar

# docker exec -it azureCli azure storage blob upload --account-name absregistry --account-key 'EvO7CQs3lobGmBN2EQ5HXXZQ+mbEbaB4cU2nR9lZfyCDeIOBAqOxvcZtI9ZXTUyMu+vd5Mngs+k9p6cJQ09QLA==' /backups/home-$(date +"%Y-%m-%d").tar jenkinsdatabackups home-$(date +"%Y-%m-%d").tar

# ### Restore volumes

# docker exec -it azureCli azure storage blob download --account-name absregistry --account-key 'EvO7CQs3lobGmBN2EQ5HXXZQ+mbEbaB4cU2nR9lZfyCDeIOBAqOxvcZtI9ZXTUyMu+vd5Mngs+k9p6cJQ09QLA==' jenkinsdatabackups log-$(date +"%Y-%m-%d").tar /backups/log-$(date +"%Y-%m-%d")-restore.tar

# docker exec -it azureCli azure storage blob download --account-name absregistry --account-key 'EvO7CQs3lobGmBN2EQ5HXXZQ+mbEbaB4cU2nR9lZfyCDeIOBAqOxvcZtI9ZXTUyMu+vd5Mngs+k9p6cJQ09QLA==' jenkinsdatabackups home-$(date +"%Y-%m-%d").tar /backups/home-$(date +"%Y-%m-%d")-restore.tar

# docker run --rm --volumes-from jenkins_data_1 -v $(pwd)/backups:/backups ubuntu bash -c "cd /var/jenkins_home && tar xvf /backups/home-$(date +"%Y-%m-%d").tar --strip 2"
# >logs

# docker run --rm --volumes-from jenkins_data_1 -v $(pwd)/backups:/backups ubuntu bash -c "cd /var/log/jenkins && tar xvf /backups/log-$(date +"%Y-%m-%d").tar --strip 3"


