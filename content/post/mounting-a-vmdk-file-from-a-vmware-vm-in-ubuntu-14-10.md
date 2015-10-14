+++
date = "2015-02-11T17:49:15"
draft = "true"
title = "Mounting a vmdk file from a VMWare VM in ubuntu 14.10"
slug = "mounting-a-vmdk-file-from-a-vmware-vm-in-ubuntu-14-10"

+++

## Fichiers initiaux

    ~/Ubuntu 14.04 64-bit # ll
    total 32G
    drwxrwxr-x  3 adrien adrien 4,0K nov.   4 17:20 caches/
    -rw-rw-r--  1 adrien adrien 8,5K nov.  25 19:10 Ubuntu 14.04 64-bit.nvram
    -rw-rw-r--  1 adrien adrien 2,0G févr. 11 17:28 Ubuntu 14.04 64-bit-s001.vmdk
    -rw-rw-r--  1 adrien adrien 2,0G févr. 11 17:28 Ubuntu 14.04 64-bit-s002.vmdk
    -rw-rw-r--  1 adrien adrien 2,0G févr. 11 17:25 Ubuntu 14.04 64-bit-s003.vmdk
    -rw-rw-r--  1 adrien adrien 2,0G févr. 11 17:27 Ubuntu 14.04 64-bit-s004.vmdk
    -rw-rw-r--  1 adrien adrien 2,0G févr. 11 17:27 Ubuntu 14.04 64-bit-s005.vmdk
    -rw-rw-r--  1 adrien adrien 2,0G févr. 11 17:27 Ubuntu 14.04 64-bit-s006.vmdk
    -rw-rw-r--  1 adrien adrien 2,0G févr. 11 17:34 Ubuntu 14.04 64-bit-s007.vmdk
    -rw-rw-r--  1 adrien adrien 2,0G févr. 11 17:30 Ubuntu 14.04 64-bit-s008.vmdk
    -rw-rw-r--  1 adrien adrien 2,0G févr. 11 17:34 Ubuntu 14.04 64-bit-s009.vmdk
    -rw-rw-r--  1 adrien adrien 2,0G févr. 11 17:27 Ubuntu 14.04 64-bit-s010.vmdk
    -rw-rw-r--  1 adrien adrien 2,0G févr. 11 17:33 Ubuntu 14.04 64-bit-s011.vmdk
    -rw-rw-r--  1 adrien adrien 2,0G févr. 11 17:27 Ubuntu 14.04 64-bit-s012.vmdk
    -rw-rw-r--  1 adrien adrien 2,0G févr. 11 17:27 Ubuntu 14.04 64-bit-s013.vmdk
    -rw-rw-r--  1 adrien adrien 2,0G févr. 11 17:27 Ubuntu 14.04 64-bit-s014.vmdk
    -rw-rw-r--  1 adrien adrien 2,0G févr. 11 17:10 Ubuntu 14.04 64-bit-s015.vmdk
    -rw-rw-r--  1 adrien adrien 1,3G févr. 11 17:10 Ubuntu 14.04 64-bit-s016.vmdk
    -rw-rw-r--  1 adrien adrien  64K févr. 11 17:10 Ubuntu 14.04 64-bit-s017.vmdk
    -rw-rw-r--  1 adrien adrien 1,6K févr. 11 16:56 Ubuntu 14.04 64-bit.vmdk
    drwxrwxr-x  2 adrien adrien 4,0K nov.  25 15:51 Ubuntu 14.04 64-bit.vmdk.lck/
    -rw-rw-r--  1 adrien adrien    0 avril 18  2014 Ubuntu 14.04 64-bit.vmsd
    -rw-rw-r--  1 adrien adrien 3,3K nov.  26 13:50 Ubuntu 14.04 64-bit.vmx
    -rw-rw-r--  1 adrien adrien 3,4K oct.  20 10:27 Ubuntu 14.04 64-bit.vmxf
    -rw-rw-r--  1 adrien adrien  11M avril 18  2014 vmmcores-1.gz
    -rw-rw-r--  1 adrien adrien  84K juil. 21  2014 vmmcores-2.gz
    -rw-rw-r--  1 adrien adrien 4,8M nov.  27 09:27 vmmcores.gz
    -rw-rw-r--  1 adrien adrien 254K nov.  21 12:07 vmware-0.log
    -rw-rw-r--  1 adrien adrien 286K nov.  18 12:03 vmware-1.log
    -rw-rw-r--  1 adrien adrien 311K nov.  13 18:12 vmware-2.log
    -rw-rw-r--  1 adrien adrien 257K nov.  25 18:01 vmware.log
    -rw-rw-r--  1 adrien adrien 235K nov.  25 19:10 vprintproxy.log


## vdfuse

- Telecharger [vdfuse](http://launchpadlibrarian.net/112699162/virtualbox-fuse_4.1.18-dfsg-1ubuntu1_amd64.deb) depuis les ppa Ubuntu, version virtualbox 4.1.18 (normalement compatible avec toute la branche 4.x)

`vdfuse -t VMDK -f /home/adrien/Ubuntu\ 14.04\ 64-bit/Ubuntu\ 14.04\ 64-bit.vmdk fs`

    # ll fs 
    total 64G
    -rw------- 1 adrien adrien  32G nov.  25 15:51 EntireDisk
    -rw------- 1 adrien adrien 243M nov.  25 15:51 Partition1
    -rw------- 1 adrien adrien  32G nov.  25 15:51 Partition5
    
## Monter Partition5
    root@gg7j15j [17:38:13]
    ~/Ubuntu 14.04 64-bit # file fs/Partition5
    fs/Partition5: LVM2 PV (Linux Logical Volume Manager), UUID: 7NBLAm-LQ52-zmsz-VQ7G-m1xy-d6f1-5xTJJ3, size: 34101788672

	kpartx -av fs/Partition5
	fdisk -l
    vgdisplay
    vgscan
	mount /dev/ubuntu-vg/root part5
    cd part5
    ll
    
bim