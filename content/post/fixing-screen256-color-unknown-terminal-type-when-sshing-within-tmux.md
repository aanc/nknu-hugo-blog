+++
date = "2014-08-05T15:12:00"
draft = "false"
title = "Fixing 'screen256-color: unknown terminal type' when ssh'ing within tmux"
slug = "fixing-screen256-color-unknown-terminal-type-when-sshing-within-tmux"
tags = ["linux","tmux","ssh"]

+++

When SSH'ing to old boxes within tmux, I sometimes get the following error:
`'screen-256color': unknown terminal type`, and a very ugly prompt.

An easy way to fix this is to set a different value for the `default-terminal` setting in your `tmux.conf`. You only have to open your `~/.tmux.conf` and add the following line:

	set -g default-terminal "xterm"

However, note that this will affect all your sessions.

If you don't want to redefine your `default-terminal` value, you can fix this only when needed by setting a different value for the `TERM` variable when you ssh to those boxes. So, instead of ssh'ing like this:

	ssh adrien@my-box

you do that:

	TERM=xterm ssh adrien@my-box

And you should not see the `'screen-256color': unknown terminal type` message anymore.
