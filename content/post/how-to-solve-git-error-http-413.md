+++
date = "2013-10-17T18:01:57"
draft = "false"
title = "How to solve Git error HTTP 413"
slug = "how-to-solve-git-error-http-413"

+++

If you have the following error when you push your repository to a remote :

    error: RPC failed; result=22, HTTP code = 413
    fatal: The remote end hung up unexpectedly
    fatal: The remote end hung up unexpectedly

The issue may not be linked to git directly, but to your webserver, which may not be able to handle big files upload. Adding the `client_max_body_size 50m;` directive to the `http` section of your `nginx.conf` file, then reload the nginx service, will solve the issue. 

*<strong>Note:</strong> you may need a higher value, depending on the size of the repository you're trying to push.*
    
