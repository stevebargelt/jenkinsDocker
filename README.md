# Automated Build System

In this series we will create an entire Automated Build System (ABS) step-by-step, from scratch using Docker, Jenkins and Go - hosted in Azure. 

Jenkins will be our CI/CD pipeline manager and it will spin up ephemeral slave nodes when needed. What I mean by that is Jenkins will spin up Docker containers as build environments that only get started when a build job needs them, so if you need a Java build environment or a DotNetcore environment, Jenkins will start a Docker container to handle your build and then destroy that node/container when the build is complete.

The tutorials:
* [Automated Build System Part 0: Intro](http://bargelt.com/blog/2016/10/06/automated-build-system-docker-jenkins-azure-go-intro/)
* [Automated Build System Part 1: Docker on Linux in Azure](http://bargelt.com/blog/2016/10/07/automated-build-system-docker-in-azure/
)

Other Artifacts:
[Tutorial Videos](http://sbarg.me/ABS-tuts)
[Intro Slides](http://sbarg.me/ABS-tuts)
[Dockhand](https://github.com/stevebargelt/Dockhand)

This repo will be used to bootstrap our system, it includes Dockerfile image definitions for all of the images and ultimately containers we need to run our system. 

Jenkins Master is a custom Jenkins image that we will use as the backbone of our automated build system, Jenkins Data (for persistent data storage or our Jenkins settings), NGINX for our web proxy, letsencrypt we will use to setup TLS/SSL on our system in part 3, and finally two sample ephemeral slave node images jenkins-slave and jenkins-dotnetcore-slave. 
