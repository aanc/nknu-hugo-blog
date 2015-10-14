+++
date = "2014-05-08T21:31:12"
draft = "false"
title = "How to create a custom RHEL install CD"
slug = "how-to-create-a-custom-rhel-install-cd"

+++

You'll need the RHEL standard installation ISO as a base, but you probably have it in one form or another if you're reading this guide ...

1. Mount the ISO somewhere

        mkdir /mnt/rhelcd
        mount /path/to/rhel-dvd.iso /mnt/rhelcd -o loop

2. Copy the content of the disk somewhere on your hard drive, so we can work on it and make our modifications.
	
        mkdir ~/workdir
        cp /mnt/rhelcd/* ~/workdir
    
	Note: There are a few dotfiles in the disk, so don't forget them, as depending on your system setup they might not be copied along when you perform the `cp`.
    
3. Create your kickstart file, describing your installation. I will not cover the creation of that file in that guide, but you can find plenty of information about that [on the internets](https://www.google.fr/search?q=how+to+create+kickstart+file&oq=how+to+create+kickstart+file&aqs=chrome..69i57j0l5.4759j0j7&sourceid=chrome&es_sm=119&ie=UTF-8). Let me know in the comments if you feel that I should add a guide for creating the kickstart file here though.

4. You can now put the kickstart file in the workdir. I like to create a dedicated folder where I put all the custom stuff I plan to add to the installation (rpms, binairies, config files, ...), but feel free to put it right in the root directory if you prefer.
		
        workdir
        ├── nknu
        │   ├── bin
        │   │   ├── some-binary-file-1
        │   │   └── some-binary-file-2
        │   ├── kickstart.cfg
        │   └── rpms
        │       ├── a-nice-rpm
        │       └── another-rpm
        └── ...
 
5. Edit the file `isolinux/isolinux.cfg` and change the following lines:

		label linux
        menu label ^Install or upgrade an existing system
        menu default
        kernel vmlinuz
        append initrd=initrd.img
to

    	label linux
        menu label ^Install or upgrade an existing system
        menu default
        kernel vmlinuz
        append initrd=initrd.img ks=cdrom://nknu/kickstart.cfg
        
 Make sure your label is either the default one or the only one, if you want the installation to be 100% unattended.

6. You can now rebuild the ISO image with your modifications by launching the following command:

		cd ~/workdir
        mkisofs -o ~/my-custom-rhel-cd.iso -b isolinux/isolinux.bin -c isolinux/boot.cat --no-emul-boot --boot-load-size 4 --boot-info-table -J -R -V disks .
        
Burn the newly created `~/my-custom-rhel-cd.iso` file on a CD (or just use it in a VM), and you're done !

<strong>Note:</strong> This should work for CentOS too, but I did not try.

Thanks for reading !

    



