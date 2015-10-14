+++
date = "2013-10-16T11:19:55"
draft = "false"
title = "How to use nginx as a reverse proxy"
slug = "how-to-use-nginx-as-a-reverse-proxy"

+++

Open the configuration file of your nginx's site, usually located in `/etc/nginx/sites-available/`, and put the following directives in your server block:

    server {
        listen 80;
        server_name your-domain.com;
        location / {
                proxy_pass http://localhost:2368;
        }
    }

This example will redirect all HTTP requests recieved on your-domain:80 to local port 2368.
