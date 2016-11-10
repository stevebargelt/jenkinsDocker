# Get timestamp
: ${BACKUP_SUFFIX:=.$(date +"%Y-%m-%d-%H-%M-%S")}
readonly tarball=$BACKUP_NAME$BACKUP_SUFFIX.tar.gz
	
# Create a gzip compressed tarball with the volume(s)
tar czf $tarball $BACKUP_TAR_OPTION $PATHS_TO_BACKUP


# Create Azure Container, if it doesn't already exist
#BUCKET_EXIST=$(aws s3 ls | grep $S3_BUCKET_NAME | wc -l)
#if [ $BUCKET_EXIST -eq 0 ]; 
#then
#  aws s3 mb s3://$S3_BUCKET_NAME
#fi

azure storage blob upload $tarball $AZURE_container_name $tarball

# ### Restore volumes

# docker exec -it azureCli azure storage blob download --account-name absregistry --account-key 'EvO7CQs3lobGmBN2EQ5HXXZQ+mbEbaB4cU2nR9lZfyCDeIOBAqOxvcZtI9ZXTUyMu+vd5Mngs+k9p6cJQ09QLA==' jenkinsdatabackups log-$(date +"%Y-%m-%d").tar /backups/log-$(date +"%Y-%m-%d")-restore.tar

# docker exec -it azureCli azure storage blob download --account-name absregistry --account-key 'EvO7CQs3lobGmBN2EQ5HXXZQ+mbEbaB4cU2nR9lZfyCDeIOBAqOxvcZtI9ZXTUyMu+vd5Mngs+k9p6cJQ09QLA==' jenkinsdatabackups home-$(date +"%Y-%m-%d").tar /backups/home-$(date +"%Y-%m-%d")-restore.tar

# docker run --rm --volumes-from jenkins_data_1 -v $(pwd)/backups:/backups ubuntu bash -c "cd /var/jenkins_home && tar xvf /backups/home-$(date +"%Y-%m-%d").tar --strip 2"
# >logs

# docker run --rm --volumes-from jenkins_data_1 -v $(pwd)/backups:/backups ubuntu bash -c "cd /var/log/jenkins && tar xvf /backups/log-$(date +"%Y-%m-%d").tar --strip 3"


