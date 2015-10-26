+++
date = "2014-07-16T17:19:44"
draft = "false"
title = "Git: setup a remote repo from a local repo"
slug = "git-setup-a-remote-repo-from-a-local-repo"
tags = ["git","howto"]

+++

Let's assume you started a new project. You're using Git for versionning, because it's easy to set it up locally, and for a few hours/days/weeks you're just happy with your local repository. However, now you need to go bigger and start sharing the code with your coworkers, or maybe want to setup a continuous integration system, or whatever else, and for that your need to create a remote repository which will act as reference for all the actors of your project.

That's quite easy to do, actually. First thing you need to do is to create a *bare repository* on your remote server. The main difference between a bare repository and a classic one (like the one on your computer), is that the bare repository does not have a working copy checked out, it only have the versionning information (which is in the `.git` folder of your local repo).

So let's create that remote repo. Connect to your remote host using ssh, and go where you want to store your repo (ie. create a folder named `repositories` in your user's home, with a sub-folder named after your project, so the repository path is `~/repositories/my-project.git`)

	$ mkdir -p ~/repositories/my-project.git
	$ cd ~/repositories/my-project.git
    $ git init --bare .
    Initialized empty Git repository in /home/adrien/repositories/my-project.git/

    $ ls -A
    branches  config  description  HEAD  hooks  info  objects  refs

That's all for the remote repository. Now we need to setup your local repo so you can push your commits to your newly created repo. We can do that with the following commands, on your local work directory:

	$ cd my-repo
    $ git add origin your-user@your-host:~/repositories/my-project.git
    $ git push origin master

And we are done ! Your coworker can now clone your repo from the remote host:

	$ git clone your-user@your-host:~/repositories/my-project.git

> <strong>Note:</strong> If you plan to have a bunch of git repositories stored here, you might want to check out [GitBlit](http://gitblit.com/), which will allow you to view and manage your git repositories easily, and serve them through http.
It would also be interresting to implement some sort of backup strategy for your repositories.
