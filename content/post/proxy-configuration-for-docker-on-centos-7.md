+++
date = "2014-09-10T10:57:23"
draft = "false"
title = "Proxy configuration for Docker on CentOS 7"
slug = "proxy-configuration-for-docker-on-centos-7"
tags = ["proxy","howto","docker","centos7"]

+++

We saw earlier how to [configure the proxy for docker on Ubuntu 14.04](http://nknu.net/running-docker-behind-a-proxy-on-ubuntu-14-04/), let's now see how to do that on CentOS 7.

Edit `/etc/sysconfig/docker` and add the following lines:

	HTTP_PROXY='http://user:password@proxy-host:proxy-port'
    HTTPS_PROXY='http://user:password@proxy-host:proxy-port'

For those settings to be taken into account, you'll need to restart your docker daemon:

	# systemctl restart docker

You may still need to declare the proxy in the Dockerfile too, as seen [in the Ubuntu article](http://nknu.net/running-docker-behind-a-proxy-on-ubuntu-14-04/).
