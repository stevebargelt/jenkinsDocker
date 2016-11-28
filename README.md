# Automated Build System

## Introduction 
This code accompanies a series of tutorials where I show you how to create an entire Automated Build System (ABS) step-by-step, from scratch using Docker, Jenkins and Go - hosted in Azure. 

It includes Dockerfile image definitions for all of the images and ultimately containers we need to run our system. It also contains scripts and other configuration artifacts to get our system up and running.  

## What are we trying to accomplish? The Outcomes
The outcomes or user stories. I approached this from two roles... 

>As a build engineer I don't want to process tickets to create build environments, build jobs, or CI/CD pipelines for software teams so that I have time to concentrate on keeping our build infrastructure healthy and have time to research and implement forward-thinking solutions for software teams to utilize. 


>As a software developer I want to control my own build environments by creating my own build jobs and CI/CD pipelines so that I can control the flow of the software I write from my machine all the way through to production without impediments like having to open a ticket or rely on other teams.

We will accomplish both of these outcomes and when we are done the process will look something like this:

* software developer (or team) creates a Docker image for the build environment (and presumably uses it locally). 
* Dev writes tests and code. 
* Dev adds a text file to code repository that contains the Jenkins pipleline script. 
* Dev pushes the image to the organization's private Docker registry. 
* Dev then uses a tool (currently command line that I've dubbed [Dockhand](https://github.com/stevebargelt/Dockhand)) to:
	* test the image and container for the basics (does it build and start?). 
	* test the image against defined standards.
	* create the buildjob/CI/CD pipeline in Jenkins.

Jenkins will be our CI/CD pipeline manager and it will spin up ephemeral slave nodes when needed. What I mean by that is Jenkins will spin up Docker containers as build environments that only get started when a build job needs them, so if you need a Java build environment or a DotNetcore environment, Jenkins will start a Docker container to handle your build and then remove that node/container when the build is complete.

## The Tutorials
* [Automated Build System Part 0: Intro](http://bargelt.com/blog/2016/10/06/automated-build-system-docker-jenkins-azure-go-intro/)
* [Automated Build System Part 1: Docker on Linux in Azure](http://bargelt.com/blog/2016/10/07/automated-build-system-docker-in-azure/
)
* [Automated Build System Part 1.5: Docker in a VM in Azure via Azure CLI](http://bargelt.com/blog/2016/11/01/build-system-azure-cli/)
* [Automated Build System Part 1.75: Docker in a VM in Azure via shell scripts and the Azure CLI](http://bargelt.com/blog/2016/11/28/abs-azure-docker-vm-setup-scripts/) 
* [Automated Build System Part 2: Custom Jenkins Container and Ephemeral Slave Nodes](http://bargelt.com/blog/2016/10/31/automated-build-system-part-custom-containers/)

## Other Artifacts
* [Tutorial Videos](http://sbarg.me/ABS-tuts)
* [Intro Slides](http://sbarg.me/ABS-slides)
* [Dockhand](https://github.com/stevebargelt/Dockhand)
