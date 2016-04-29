+++
date = "2016-04-12T12:30:23"
draft = "false"
title = "How to mount your android phone on fedora 23 using simple-mtpfs"
slug = "mount-nexus5-on-fedora23-using-simple-mtpfs"
tags = ["linux","fedora","nexus","mtp","howto"]

+++

On recent Fedora versions, it should works out of the box: you plug the phone, the system detects it and opens a file explorer allowing you to browse your device's content.

However, if for some reason you want to mount the phone using `simple-mtpfs`, you can proceed as follow.

- Install `simple-mtpfs`

```
$ dnf install simple-mtpfs
```

**Note** : you also need the packages `fuse fuse-libs libmtp`, but chances are that they are already installed on your system.

- Connect your device (in my case, a LG Nexus 5), and do a `dmesg | tail` :

```
[ 4158.530224] usb 4-1.7.2: new high-speed USB device number 4 using ehci-pci
[ 4158.616409] usb 4-1.7.2: New USB device found, idVendor=18d1, idProduct=4ee1
[ 4158.616415] usb 4-1.7.2: New USB device strings: Mfr=1, Product=2, SerialNumber=3
[ 4158.616418] usb 4-1.7.2: Product: Nexus 5
[ 4158.616421] usb 4-1.7.2: Manufacturer: LGE
[ 4158.616423] usb 4-1.7.2: SerialNumber: xxxxxxxxxxxxxxxxxxxxxx
```

Write down the `idVendor` and `idProduct` values.

- create file `/etc/udev/rules.d/10-phone.rules`

```
SUBSYSTEM=="usb", ATTR{idVendor}=="18d1", ATTR{idProduct}="4ee1", SYMLINK="nexus5"
```

**Note:** Make sure to replace the `ATTR{idVendor}` and `ATTR{idProduct}` values with the one you got from the `dmesg | tail` command, and the `SYMLINK` value with whatever you want - it will be the name of the symbolic link udev will create in your `/dev` folder, pointing to your device.

- reload udev rules :

```
$ sudo udevadm control --reload-rules
```

- unplug/replug your device. You should now have a file in `/dev` named as requested in the udev rules file created earlier.

```
$ ls -l /dev/nexus5
lrwxrwxrwx. 1 root root 15 Jan 12 10:44 /dev/nexus5 -> bus/usb/004/005
```

- Make sure the phone is in MTP mode. You can check that directly on the phone, on your notification area, you should have a notification saying "USB for file transfers" (or something similar). If you have "USB for charging", tap on the notification, and on the poping menu select "USB for file transfers (MTP)".

- Mount the phone

```
$ simple-mtpfs /dev/nexus5 /tmp/test
$ ls /tmp/test

Alarms    cinegroup          Documents      Movies         panoramas      Ringtones   vervewireless
...
```

Et voilà!

