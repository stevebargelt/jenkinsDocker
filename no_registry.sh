#!/usr/bin/env bash

if [ ! -d $HOME/jenkinsDockerjenkins-nginx/files ]; then
	mkdir -iv jenkins-nginx/files
	touch jenkins-nginx/files/registry.password
	mkdir -iv jenkins-nginx/certs
	touch jenkins-nginx/files/registry.password
	touch jenkins-nginx/certs/domain.crt
	touch jenkins-nginx/certs/domain.key 
fi 

# swap this to just swap the registry.conf extenstion??
cp jenkins-nginx/conf/nginx_noreg.conf jenkins-nginx/nginx.conf
