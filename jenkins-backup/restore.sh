#!/bin/bash

# Find last backup file
: ${LAST_BACKUP:=$(azure storage blob list $AZURE_container_name| awk -F " " '{print $2}' | grep ^$BACKUP_NAME | sort -r | head -n1)}

# Download backup from Azure
azure storage blob download $AZURE_container_name $LAST_BACKUP $LAST_BACKUP

# Extract backup
tar xzf $LAST_BACKUP $RESTORE_TAR_OPTION