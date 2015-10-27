+++
date = "2014-04-08T13:19:07"
draft = "false"
title = "Gain root permission inside VI with sudo"
slug = "gain-root-permission-inside-vi"
tags = ["vi","linux"]

+++

If you open a file owned by root in VI with your regular user, you will be unable to save it using the regular `:w` command as the file will be opened read-only.

However you can write the content of your vi buffer to the file using the command `:w !sudo tee %`, which will prompt for your sudo password.

If you don't want to remember this line, you can add the following line to your `.vimrc` file:
`cmap w!! w !sudo tee % >/dev/null`

Now, you just have to type `:w!!` to call the command.
