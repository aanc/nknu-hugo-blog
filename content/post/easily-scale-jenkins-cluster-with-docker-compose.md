+++
date = "2016-10-10T12:30:23"
draft = "true"
title = "How to easily scale your Jenkins cluster with Docker Compose"
slug = "easily-scale-jenkins-cluser-with-docker-compose"
tags = ["linux","docker","compose","jenkins","howto"]

+++

Jenkins is a wonderful tool.
Its original purpose was to do continuous integration of code, but now it has grown into something that can automate and orchestrate almost everything.
With more and more tasks handled by Jenkins, we need to allocate more an more ressources to its cluster.

== Setup a Jenkins master

Note: if you already have a Jenkins master running, you can skip this step.

Create a `docker-compose.yml` file containing the following:

	version: '2'
	services:
	  jenkins_master:
	    image: jenkins:2.7.4
	    volumes:
	      - jenkins_home:/var/jenkins_home
	      - /etc/localtime:/etc/localtime:ro
	    ports:
	      - "8080:8080"
	      - "50000:50000"

	volumes:
	  jenkins_home:{}

Start your Jenkins master with the command `docker-compose up -d`, and browse to `http://your-docker-host:8080` to do the initial Jenkins setup.

Note: there is a security step during the setup that ask you to copy/paste the content of a file on the master.
You can use `docker-compose exec jenkins_master cat /var/jenkins_home/secrets/initialAdminPassword` to get it.

== Create a dedicated user in Jenkins Administration, with enough rights to add agents

Go to Jenkins' Administration page and create a new user called "agent", with the following permissions:
- Agent: build, configure, connect, create, delete, disconnect
- Global: read

This is the user our future agents will use to register themselves to the Jenkins master.

== Create the Jenkins Agent image(s) that fit your needs

For this exemple we will create an agent based on the `centos:7` docker image, but we can use any image as base, as long as we put java8 and the jenkins swarm client in it.
Create a `Dockerfile` with the following content:

	FROM centos:7

	RUN yum install -y epel-release
	RUN yum install -y \
	        aria2 \
	        curl \
	        git \
	        java-1.8.0-openjdk.x86_64 \
	        jq \
	        unzip \
	        wget \
	        which \
	        && wget https://repo.jenkins-ci.org/releases/org/jenkins-ci/plugins/swarm-client/2.2/swarm-client-2.2-jar-with-dependencies.jar -O /root/swarm-client.jar

	ENTRYPOINT ["/usr/bin/java", "-jar", "/root/swarm-client.jar"]

Now build it with `docker build -t local/jenkins-centos7-slave .`.

Note: we could also ask Docker Compose to manage the image for us, by declaring the Dockerfile in the compose file, but I prefer not to.

== Declare the agent in the `docker-compose.yml` file

Add the service to your `docker-compose.yml` file:

	  jenkins_centos7_slave:
	    image: local/jenkins-centos7-slave
	    command: -master http://<your-jenkins-host-ip>:8080 -username agent -password <your-jenkins-agent-user-password> -name centos7
	    volumes:
	      - /etc/localtime:/etc/localtime:ro

You can start the agent with `docker-compose up -d`.
After a few seconds, it should appear in your Jenkins master interface.
If not, check the container's logs with `docker-compose logs jenkins_centos7_slave` and use that info to troubleshout the issue.

We can now easily add and remove agents with the `docker-compose scale` command, ie: `docker-compose scale jenkins_centos7_slave=3` would pop 2 slave that would automatically join your Jenkins cluster.

Now we could imagine adding other kind of agents to jenkins, using the same method with differents agent images (ie. a debian based image, or one specialized in npm builds, or a windows based image, ...)
We could also automate it further using the Jenkins Docker plugin to start the specific types of agents only when a build needs them, with on-demand agent creation.
That will be the subject of a future article.
