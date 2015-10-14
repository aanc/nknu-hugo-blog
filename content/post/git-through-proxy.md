+++
date = "2014-05-30T12:47:43"
draft = "false"
title = "Git behind a proxy"
slug = "git-through-proxy"

+++

If you need to access a git repository somewhere on the internet (let's say on GihHub) from your workstation which is inside your corporate network, chances are that you'll need to go through an HTTP proxy. Let's see how we can configure that.

#### Option 1 : Environment variables
Git honor the environment variables `http_proxy` and `https_proxy`, so one way of solving our problem is setting those variables as follow:

	http_proxy='http://proxy_host:proxy_port'
    https_proxy=$http_proxy
    
If your proxy requires authentication, you need  to specify your user/password in the URL:

	http_proxy='http://username:password@proxy_host:proxy_port'
    
If you need more info about setting proxy info in your environment, check [that article I wrote about that a few month back](http://nknu.net/ubuntu-14-04-proxy-authentication-config/).

#### Option 2 : Git's variable http.proxy

Git also check what's in its own `http.proxy` variable, so you can set it on a per-project basis with the following command:

	git config http.proxy 'http://username:password@proxy_host:proxy_port'
    
or on your global git configuration with this one:

	git config --global http.proxy 'http://username:password@proxy_host:proxy_port'

Et voilà ! You should now be able to clone your external repo (ie. on GitHub).
#### Okay, this got http:// and https:// repo working, but what about git:// ?

If the settings above did not solve your problem when cloning repositories using the `git://` protocol. That's a solid hint that your network config does not allow you to connect to remote port 9418, which is used by git's own protocol.

You have an easy way and a hard way to work arround that.

<strong>The easy way</strong> is to use the HTTP protocol instead of the git protocol. You can tell git to do that with the almost magical `url.<>.insteadOf` command.

	git config --global url.https://github.com/.insteadOf git://github.com/

That basically tells git to systematically replace `git://github.com` with `https://github.com` when you call an external URL, resolving our problem.

<strong>The hard way</strong> is to use corkscrew or socat to proxy your connection through the http proxy. You'll need to do that if `git://` is the only protocol your remote repository is exposing. I've never seen such a repo, so that's something I did not try, but [here is a page describing how to do it](http://gitolite.com/git-over-proxy.html#proxying-the-git-protocol).

<center>
<script async src="//pagead2.googlesyndication.com/pagead/js/adsbygoogle.js"></script>
<!-- In article -->
<ins class="adsbygoogle"
     style="display:inline-block;width:468px;height:60px"
     data-ad-client="ca-pub-9470959665799736"
     data-ad-slot="4075034603"></ins>
<script>
(adsbygoogle = window.adsbygoogle || []).push({});
</script>
</center>