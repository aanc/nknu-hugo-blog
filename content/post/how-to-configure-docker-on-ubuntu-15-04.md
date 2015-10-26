+++
date = "2015-05-26T16:13:55"
draft = "false"
title = "How to configure Docker on Ubuntu 15.04 (workaround)"
slug = "how-to-configure-docker-on-ubuntu-15-04"
tags = ["ubuntu","docker","workaround","15.04","vivid"]

+++

__Article updated the 17th of August 2015,__ with the remarks of _Giacomo Orlandi_ in the comments, who provided a cleaner way to update the systemd config, based on a discussion in [this Docker's Github issue](https://github.com/docker/docker/issues/9889#issuecomment-109819996).

If you upgraded (or fresh-installed) your box to Ubuntu 15.04, you may have noticed that the Docker daemon is not using the configuration defined in `/etc/default/docker` anymore. That is due to the fact that Ubuntu is now using `systemd` instead of Upstart/SysV. Unfortunately, Docker's default systemd configuration is not ready for Ubuntu, and the config file is ignored.

There is some [work](https://github.com/docker/docker/pull/13439) [in](https://github.com/docker/docker/issues/12926) [progress](https://github.com/docker/docker/issues/13384) on Docker's side to fix that, but you may want to have a workaround in order to have it working until the official fix is released (hopefully with Docker 1.7).

First thing to do is to confirm that systemd is in charge of your Docker service. We can do that by simply asking systemd to give us Docker's status, with the `systemctl status docker` command :

	 $ systemctl status docker
	● docker.service - Docker Application Container Engine
	   Loaded: loaded (/lib/systemd/system/docker.service; enabled; vendor preset: enabled)
	   Active: active (running) since mar. 2015-05-26 14:52:45 CEST; 58min ago
	     Docs: http://docs.docker.com
	 Main PID: 20075 (docker)
	   Memory: 198.2M
	   CGroup: /system.slice/docker.service
	           ├─20075 /usr/bin/docker -d -H fd://

Two things are interresting in this output. The first one is that we can see that the docker daemon is launched with parameter `-H fd://`, and nothing else (in my case, it should have some DNS declared, and an insecure registry - see the `DOCKER_OPTS` line of your `/etc/default/docker` file). The second one is that the systemd configuration file which is used is `/lib/systemd/system/docker.service`.

Let's see what it looks like :

	$ cat /lib/systemd/system/docker.service
	[Unit]
	Description=Docker Application Container Engine
	Documentation=http://docs.docker.com
	After=network.target docker.socket
	Requires=docker.socket

	[Service]
	ExecStart=/usr/bin/docker -d -H fd://
	MountFlags=slave
	LimitNOFILE=1048576
	LimitNPROC=1048576
	LimitCORE=infinity

	[Install]
	WantedBy=multi-user.target

Ahah ! Here is our issue: the execution command defined in the `ExecStart` line is static: it does not use the variables defined in the `/etc/default/docker` file. In order to have the file loaded, we need to declare `/etc/default/docker` as an [EnvironmentFile](http://fedoraproject.org/wiki/Packaging%3aSystemd#EnvironmentFiles_and_support_for_.2Fetc.2Fsysconfig_files), and use the `DOCKER_OPTS` variable in the `ExecStart` line.

Systemd allow the user to override the default value in the config file by creating `*.conf` files in a specific folder. We will need to create that folder, if it does not exist:

	$ mkdir -p /etc/systemd/system/docker.service.d

Now, we can create our config override file in that folder :

	$ vi /etc/systemd/system/docker.service.d/ubuntu.conf

containing the follwing lines:

	$ [Service]
    # workaround to include default options
    EnvironmentFile=/etc/default/docker
    ExecStart=
    ExecStart=/usr/bin/docker -d -H fd:// $DOCKER_OPTS


Now, reload systemd's config with `systemctl daemon-reload` , and restart the Docker daemon in order to load the config file, with `systemctl restart docker`, and run a `systemctl status docker` to confirm that the config file has been loaded:

	  ● docker.service - Docker Application Container Engine
     Loaded: loaded (/lib/systemd/system/docker.service; enabled; vendor preset: enabled)
    Drop-In: /etc/systemd/system/docker.service.d
             └─ubuntu.conf
     Active: active (running) since lun. 2015-08-17 15:29:39 CEST; 13min ago
       Docs: http://docs.docker.com
     Memory: 3.9M
     CGroup: /system.slice/docker.service
             ├─16089 /usr/bin/docker -d -H fd:// --dns 10.200.1.11 --dns 8.8.8.8 --insecure-registry insecure-registry:5000
             └─17194 docker-proxy -proto tcp -host-ip 0.0.0.0 -host-port 43128 -container-ip 172.17.0.1 -container-port 3128

We can see the correct parameters in the Docker daemon command line, so it seems that `DOCKER_OPTS` has been taken into account.

You will have one more thing to do if you declared variables other than `DOCKER_OPTS` in the `/etc/default/docker` file (ie. proxy configuration) : remove the exports. Systemd does not source the configuration file, it only loads declared variables into the process' environment, so the lines that begin with `export` will be ignored. If you have some of those lines in your configuration file, you will have to remove the word `export`, and restart Docker's daemon. The following `sed` command will do that for you: `sed -i -e "s/^export //" -e "s/#export /#/" /etc/default/docker`. Try to pull an image from Docker Hub in order to confirm that everything is OK.

With this workaround, you should be able to use Docker as usual on your Ubuntu 15.04 Vivid. However, don't forget that *it's only a workaround*, and not a very pretty one ! So be sure to update your Docker package as soon as Ubuntu Vivid's compatibility is officialy fixed !

Thanks for reading, hope it helped.
