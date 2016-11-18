+++
date = "2016-10-27T14:45:39"
draft = "false"
title = "Fix virtualbox Linux guest boot blackscreen after kernel upgrade"
slug = "fix-vbox-linux-guest-boot-blackscreen-after-kernel-upgrade"

+++

I run a fedora 24 as a Virtualbox VM on a windows host. The other day, after a kernel upgrade of this VM and rebooting, I got a black screen. Here is what I did to fix it :

* Reboot your VM and select a previous kernel with grub's menu. If you don't have one available, I guess you'll have to boot in recovery mode and install one.
* Login as root
* Execute `rcvboxadd cleanup` - it will delete your currently installed guest additions
* Reboot on new kernel (should boot now, but guest additions KO), and login as root
* Install kernel-headers and kernel-devel of your current kernel version
* Mount VBox Guest Additions ISO, and execute `VBoxLinuxAdditions.run`
* Reboot (still on new kernel), and everything should be fine now.

Hope it helped.

