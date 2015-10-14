+++
date = "2014-09-10T10:32:00"
draft = "false"
title = "Running docker behind a proxy on Ubuntu 14.04"
slug = "running-docker-behind-a-proxy-on-ubuntu-14-04"

+++

If you're behind a proxy, chances are that docker is failing to build your containers, as it is not able to pull base images, and commands in the Dockerfile that need to access the internet are failing. Let's see how to fix that.

<script async src="//pagead2.googlesyndication.com/pagead/js/adsbygoogle.js"></script>
<!-- In article -->
<ins class="adsbygoogle"
     style="display:inline-block;width:468px;height:60px"
     data-ad-client="ca-pub-9470959665799736"
     data-ad-slot="4075034603"></ins>
<script>
(adsbygoogle = window.adsbygoogle || []).push({});
</script>

Edit `/etc/defaults/docker.io` and add the following lines:

	export http_proxy='http://user:password@proxy-host:proxy-port'

For those settings to be taken into account, you'll have to restart your docker daemon:

	$ sudo service docker.io restart
    
This should allow docker daemon to pull images from the central registry. However, if you need to configure the proxy in the Dockerfile (ie. if you're using `apt-get` to install packages), you'll need to declare it there too.

Add the following lines at the top of your Dockerfile:

	ENV http_proxy 'http://user:password@proxy-host:proxy-port'
    ENV https_proxy 'http://user:password@proxy-host:proxy-port'
    ENV HTTP_PROXY 'http://user:password@proxy-host:proxy-port'
    ENV HTTPS_PROXY 'http://user:password@proxy-host:proxy-port'
    
With those settings, your container should now build, using the proxy to access the outside world.

<script async src="//pagead2.googlesyndication.com/pagead/js/adsbygoogle.js"></script>
<!-- In article -->
<ins class="adsbygoogle"
     style="display:inline-block;width:468px;height:60px"
     data-ad-client="ca-pub-9470959665799736"
     data-ad-slot="4075034603"></ins>
<script>
(adsbygoogle = window.adsbygoogle || []).push({});
</script>