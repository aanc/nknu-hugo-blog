+++
date = "2014-05-14T11:22:01"
draft = "false"
title = "apt-get install error at run-parts zz-update-grub"
slug = "apt-get-install-error-at-run-parts-zz-update-grub"
tags = ["linux","debian","fix","grub"]

+++

When you install programs using `apt-get`, post-install tasks are executed to keep the system consistent. However, sometimes, those tasks does not go well, as in the example below (on a Debian Squeeze - yeah, I know, this system is not really up to date ...).

    $ apt-get install whatever
    ...
    Running depmod.
    Running update-initramfs.
    update-initramfs: Generating /boot/initrd.img-2.6.32-5-amd64
    Examining /etc/kernel/postinst.d.
    run-parts: executing /etc/kernel/postinst.d/initramfs-tools 2.6.32-5-amd64 /boot/vmlinuz-2.6.32-5-amd64
    run-parts: executing /etc/kernel/postinst.d/zz-update-grub 2.6.32-5-amd64 /boot/vmlinuz-2.6.32-5-amd64
    Generating grub.cfg ...
    /usr/sbin/grub-probe: error: Couldn't find PV pv3. Check your device.map.
    run-parts: /etc/kernel/postinst.d/zz-update-grub exited with return code 1
    Failed to process /etc/kernel/postinst.d at /var/lib/dpkg/info/linux-image-2.6.32-5-amd64.postinst line 799.
    dpkg : erreur de traitement de linux-image-2.6.32-5-amd64 (--configure) :
     le sous-processus script post-installation installé a retourné une erreur de sortie d'état 1
    configured to not write apport reports
                                          Des erreurs ont été rencontrées pendant l'exécution :
     linux-image-2.6.32-5-amd64
    E: Sub-process /usr/bin/dpkg returned an error code (1)

In that case, the cause seems to be a corrupted GRUB device map, as stated in the error message.
This device.map file can be found in your /boot/grub folder, and is a list of device where GRUB will look for a boot configuration.
For example, when not corrupted, mine looks like:

    $ cat /boot/grub/device.map
    (fd0)   /dev/fd0
    (hd0)   /dev/sda
    (hd1)   /dev/sdb
    (hd2)   /dev/sdc
    (hd3)   /dev/sdd

In order to fix our issue, we need to generate a new device map. It can be done easily with the following command:

    $ grub-mkdevicemap

Once done, resume the post-install tasks using the `dpkg --configure --pending` command:

    # dpkg --configure --pending
    Paramétrage de linux-image-2.6.32-5-amd64 (2.6.32-48squeeze1) ...
    Running depmod.
    Running update-initramfs.
    update-initramfs: Generating /boot/initrd.img-2.6.32-5-amd64
    Examining /etc/kernel/postinst.d.
    run-parts: executing /etc/kernel/postinst.d/initramfs-tools 2.6.32-5-amd64 /boot/vmlinuz-2.6.32-5-amd64
    run-parts: executing /etc/kernel/postinst.d/zz-update-grub 2.6.32-5-amd64 /boot/vmlinuz-2.6.32-5-amd64
    Generating grub.cfg ...
    Found linux image: /boot/vmlinuz-2.6.32-5-amd64
    Found initrd image: /boot/initrd.img-2.6.32-5-amd64
    done

You can now re-launch your initial `apt-get install` command in order to make sure everything is OK, and it should now exit without any error message.
