+++
date = "2015-05-01T22:56:06"
draft = "false"
title = "How to easily deploy your ghost blog using docker-machine and docker-compose"
slug = "how-to-deploy-your-ghost-blog-using-docker-machine-and-docker-compose"
tags = ["ghost","docker","compose","machine"]

+++

## Prepare your docker host (with docker-machine)

First step is to have a docker-ready server. We have several ways of doing that: we can install docker on our server by hand (from packages, from source, using docker.io neat curl|sh, ...), we can use boot2docker, or we can user docker machine to directly provision a server for us. We'll do the later as it's reeeaallly easy, with Virtualbox as provider. You'll need to have Virtualbox installed on your machine. Feel free to use any other provider, if you don't want to use Virtualbox : it should not have any impact on the rest of the guide (you can deploy on DigitalOcean, [Runabove](https://community.runabove.com/kb/en/instances/docker-in-5-minutes-on-runabove-with-docker-machine.html), ...).

Installing docker-machine on our workstation is as easy as copying the executable corresponding to our OS somewhere in your path. Check [this page](https://docs.docker.com/machine/#installation) to have the latest instructions about docker-machine's installation. In my case I'm running on Ubuntu, so I'll take the `docker-machine_linux64` executable and copy it to `/usr/local/bin/docker-machine`.

Now that we have installed docker-machine, creating a docker host is really straightfoward :

	$ docker-machine create -d virtualbox ghost
	INFO[0000] Creating client certificate: /home/adrien/.docker/machine/certs/cert.pem
	INFO[0000] Creating SSH key...                          
	INFO[0000] Image cache does not exist, creating it at /home/adrien/.docker/machine/cache...
	INFO[0000] No default boot2docker iso found locally, downloading the latest release...
	INFO[0001] Downloading latest boot2docker release to /home/adrien/.docker/machine/cache/boot2docker.iso...
	INFO[0050] Creating VirtualBox VM...                    
	INFO[0058] Starting VirtualBox VM...                    
	INFO[0059] Waiting for VM to start...                   
	INFO[0104] "ghost" has been created and is now the active machine.
	INFO[0104] To point your Docker client at it, run this in your shell: eval "$(docker-machine env ghost)"

With that output, we can be pretty confident that our machine was successfuly created, but if you need an extra confirmation you can check that the machine is indeed running in your Virtualbox Manager.

![](/content/images/2015/04/GhostDockerMachine.png)

As suggested by the output of docker-machine, we can now run `eval "$(docker-machine env ghost)"` in order to point our docker client to this newly created docker daemon, so every `docker` command we'll run from now will be sent to the docker daemon in the machine we just created.

## Starting Ghost in a container

At this point we have a docker machine ready to run our containers. Let's run standard Ghost container on it, in order to check that everything is OK.
Docker Hub provides [an official Ghost image](https://registry.hub.docker.com/u/library/ghost/) which we will use (you can see how it's built [here](https://github.com/docker-library/ghost). Let's run it and see how it goes :

	$ docker run --rm ghost

	> ghost@0.6.0 start /usr/src/ghost
	> node index

	Migrations: Database initialisation required for version 003
	Migrations: Creating tables...
	Migrations: Creating table: posts
	Migrations: Creating table: users
	Migrations: Creating table: roles
	Migrations: Creating table: roles_users
	Migrations: Creating table: permissions
	Migrations: Creating table: permissions_users
	Migrations: Creating table: permissions_roles
	Migrations: Creating table: permissions_apps
	Migrations: Creating table: settings
	Migrations: Creating table: tags
	Migrations: Creating table: posts_tags
	Migrations: Creating table: apps
	Migrations: Creating table: app_settings
	Migrations: Creating table: app_fields
	Migrations: Creating table: clients
	Migrations: Creating table: accesstokens
	Migrations: Creating table: refreshtokens
	Migrations: Populating fixtures
	Migrations: Populating permissions
	Migrations: Creating owner
	Migrations: Populating default settings
	Migrations: Complete
	Ghost is running in development...
	Listening on 0.0.0.0:2368
	Url configured as: http://localhost:2368
	Ctrl+C to shut down

That seems nice ! Ghost is running inside a container, on the machine we provisioned with docker-machine. How do access it now ? Well, we don't. As you can see in the logs, Ghost is running on `localhost:2368`, but `localhost` here does not mean our local box, but the docker container. In order to access this port, we need to tell docker that it needs to forward it somewhere we can access, and that is done with the `-P`, which forward all the ports declared in the Dockerfile to random accessible ports, or `-p <port_we_want_to_use>:<port_we_want_to_access>` which let us choose which port we want to access, and where.
So, let's hit `Ctrl+C` in order to stop our Ghost container, and relaunch it with the `-p` option :

	$ docker run --rm -p 9999:2368 ghost

We will need to get the address of the docker host in order to access it. It's really easy to get: we only have to ask docker-machine for it :

	$ docker-machine ip ghost
	192.168.56.77

Now open your favorite browser and go to this address, on port 9999 (for me it would be `http://192.168.56.77:9999`) and you should see Ghost running.

![](/content/images/2015/04/Ghost.png)

## Persisting our content

Ok, now we are able to launch Ghost in a docker container. However, _everything_ is in the container, including you data, and that's not really what we want. Let's see how we could use docker's volumes to our advantage.
The only things we need to persist in Ghost are our config file, `config.js`, and the `content/` folder, where our themes are stored, and more importantly our blog posts. The Ghost docker image we're using is making our life easier, as it is built to accept a volume that will be mapped to the Ghost's `content/` folder, and will look into this folder for a `config.js` file that will be used in place of the image's default one. So we can map only one folder, containing everything we need, and this folder will be everything we need to care about (ie. for backups).

You can re-use the `content` folder of your existing blog, if you want to migrate. If you start from scratch, you can simply download the latest Ghost package and extract it from there.

	$ wget https://ghost.org/zip/ghost-latest.zip
	$ unzip ghost-latest.zip "content/*"
	$ rm -f ghost-latest.zip

Now you can run the Ghost image, using that `content/` folder as a volume :

	$ docker run --rm -p 9999:2368 -v $(pwd)/content:/var/lib/ghost ghost

**Note:** In case it's not clear, `$(pwd)/content` means "my current working directory, concatenated to `/content`". You could replace it with something like `-v /home/adrien/sandbox/ghost-docker/content`, but for the sake of copy&paste I tried to put something more general.

## Adding some simplicity with docker-compose

Ok so now our blog is running inside a container, Ghost's port is exposed, content folder is mapped, and we're quite happy. We could leave it that way and go do some other stuff, but we used a quite complex command line to launch the blog, and who knows if by the time we need to relaunch it we'll remember it ?
Well, we could avoid the need to remember it by using [docker-compose](https://docs.docker.com/compose/).

> Compose is a tool for defining and running complex applications with Docker. With Compose, you define a multi-container application in a single file, then spin your application up in a single command which does everything that needs to be done to get it running.
> -- <cite>https://docs.docker.com/compose</cite>

Well, our application is not per say "complex", but we can use compose anyway (so we can be lazy later).

The only thing to do, besides [installing compose on our box](https://docs.docker.com/compose/#installation-and-set-up), is to create a simple YAML file, named `docker-compose.yml`.

	blog:
	  image: ghost
	  command: npm start
	  volumes:
	    - content:/var/lib/ghost
	  ports:
	    - 9999:2368

We can now run the blog with the command :

	$ docker-compose up -d

The `-d` flag tells docker to launch the container in the background. We can check that it's correctly running with a classic `docker ps`

	$ docker ps
	CONTAINER ID        IMAGE               COMMAND                CREATED             STATUS              PORTS                    NAMES
	9a626c13449d        ghost:0             "/entrypoint.sh npm    7 seconds ago       Up 6 seconds        0.0.0.0:9999->2368/tcp   blogcompose_blog_1

## What's next ?

We've seen how to setup the blog using docker, machine and compose and now we need to think about exploiting it ! A good next step would be to setup a backup, a script copying our `content` folder and our `docker-compose.yml` file somewhere safe. We could also add a custom theme to our newly created blog, by putting it in our `content/themes/` folder and restarting the container.

Or we could simply connect to Ghost, and start writing stuff ! Happy blogging !
