+++
date = "2014-04-07T14:42:17"
draft = "false"
title = "VMware CLI unattended install, aka auto-answering 'yes'"
slug = "vmware-cli-unattended-install-aka-auto-answering-yes"

+++

Today I had to automate the process of installing VMware Perl SDK (part of the [VMware CLI tools](https://my.vmware.com/fr/web/vmware/details?downloadGroup=VSP510-VCLI-510&productId=285)) on a RHEL 6.4 box. The manual procedure is quite simple and [well documented on VMware's website](http://pubs.vmware.com/vsphere-55/index.jsp#com.vmware.perlsdk.install.doc/cli_install.3.1.html), and it even has a very handy "default" option that automatically choose default settings during install without prompting for confirmation.
However at the very begining you have to read the VMware terms and conditions, and type "yes" to accept them. That step was preventing my script from working 100% unattended.

That's where I discovered the existence of the `yes` command. You juste pipe it into your install script, and it answer yes to everything !

`yes | ./vmware-install.pl default`

In the case of VMware CLI, before accepting the terms and conditions you have to read them. And to do that, the install script is calling the default system pager (which was `more` in my case). That's one more blocking point as you need to either read it entirely (and scrolling down manually), or press `q` to exit. You can workarround this by redefining the default pager for your install script by surcharging the PAGER environment variable:

`yes | PAGER=cat ./vmware-install.pl default`

and BOOM!, 100% interaction-free VMware CLI install, that you can put in your headless scripts.

Oh, and in case you need to say "no", just `yes no` !
