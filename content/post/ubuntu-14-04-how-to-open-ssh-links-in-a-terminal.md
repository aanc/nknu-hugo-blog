+++
date = "2014-08-07T12:05:32"
draft = "false"
title = "Ubuntu 14.04: How to open ssh:// links in a terminal"
slug = "ubuntu-14-04-how-to-open-ssh-links-in-a-terminal"

+++

If you're using a web based tool to manage your servers, chances are that this tool is providing `ssh://` links to connect directly to those server with one click from your web browser. Let's see how to setup Ubuntu 14.04 so it can handle this type of link.

<script async src="//pagead2.googlesyndication.com/pagead/js/adsbygoogle.js"></script>
<!-- In article -->
<ins class="adsbygoogle"
     style="display:inline-block;width:468px;height:60px"
     data-ad-client="ca-pub-9470959665799736"
     data-ad-slot="4075034603"></ins>
<script>
(adsbygoogle = window.adsbygoogle || []).push({});
</script>

First we need a script which is able to process a string like "ssh://user@host:port". Create a file named `ssh-handler.sh` somewhere in your home directory (ie. `~/.local/bin/ssh-handler.sh` - I tend to put my custom executables in ~/.local/bin, and I added that to my PATH)

	#!/bin/sh
    d=${1#ssh://}
    gnome-terminal -e "ssh $d" &
    
Make it executable with a `chmod a+x ~/.local/bin/ssh-handler.sh`.
If you want to test it, open an `xterm` (so we can make sure the script will open gnome-terminal by itself), and execute `~/.local/bin/ssh-handler.sh ssh://localhost`. This should open a gnome-terminal window, prompting you for your local password (provided that you have an sshd running on your local machine).

Now we need to create a `.desktop` file which will use the handler we just created. Create a file in `~/.local/share/applications/` named `ssh-handler.desktop`, with the following content:

	[Desktop Entry]
	Type=Application
	Name=SSH Handler
	Exec=ssh-handler.sh %u
	Icon=utilities-terminal
	StartupNotify=false
	MimeType=x-scheme-handler/ssh;
    
> <strong>Important</strong>: if your `~/.local/bin` folder is not in your PATH variable, you will have to specify the full path of the `ssh-handler.sh` script in the `Exec=` line, ie. `Exec=/home/adrien/.local/bin/ssh-handler.sh`

Once this file is created, the last step is to tell the system that the SSH links should be handled by default by this desktop entry. Before we do that, it can be a good idea to check that nothing is currently handling the SSH protocol, or if something is handling it make sure that we can replace it safely. To check that, run the following command:

	xdg-mime query default x-scheme-handler/ssh

If the output is blank, we're good ! It not, use your best judgement to decide if you want to replace it or not.

Now we can run the following command to define our `ssh-handler.desktop` file as the default handler for ssh protocol:

	xdg-mime default ssh-handler.desktop x-scheme-handler/ssh

And that's it ! Clicking on `ssh://...` links in your browser should now directly open a terminal window and connect to the specified host.

<script async src="//pagead2.googlesyndication.com/pagead/js/adsbygoogle.js"></script>
<!-- Test ad -->
<ins class="adsbygoogle"
     style="display:inline-block;width:468px;height:60px"
     data-ad-client="ca-pub-9470959665799736"
     data-ad-slot="7479486209"></ins>
<script>
(adsbygoogle = window.adsbygoogle || []).push({});
</script>
