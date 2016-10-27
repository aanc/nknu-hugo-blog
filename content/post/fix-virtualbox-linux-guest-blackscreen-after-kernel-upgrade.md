+++
date = "2016-10-27T14:45:39"
draft = "true"
title = "Fix virtualbox Linux guest boot blackscreen after kernel upgrade"
slug = "fix-vbox-linux-guest-boot-blackscreen-after-kernel-upgrade"

+++

* Linux Fedora 24 get kernel upgrade
* Reboot
* Black screen
* Reboot
* Select previous kernel at grub menu
* Login as root
* Execute `rcvboxadd cleanup`
* Reboot on new kernel (should boot now, but guest additions KO)
* Login as root
* Install kernel-headers and kernel-devel of your current kernel version
* Mount VBox Guest Additions ISO, and execute `VBoxLinuxAdditions.run`
* Reboot
* The End
