+++
date = "2016-11-23T12:21:03"
draft = "false"
title = "Bash shortcuts cheatsheet"
slug = "bash-shortcuts-cheatsheet"
tags = ["bash", "linux", "cheatsheet"]

+++

## Moving around

| Shortcut      | Action
| :-----------: | ------
| `Alt + b`     | Move cursor to previous word
| `Alt + f`     | Move cursor to next word
| `Ctrl + b`    | Move back a char
| `Ctrl + f`    | Move forward a char
| `Ctrl + a`    | Jump to the start of the line
| `Ctrl + e`    | Jump to the end of the line

## Deleting, copying, completing, transforming, ...

| Shortcut      | Action
| :-----------: | ------
| `Alt + .`     | Yank last argument to previous command
| `Alt + *`     | Insert all possible completions
| `Alt + /`     | Attempt to complete filename
| `Alt + backspace` | Delete word backward from cursor
| `Alt + c`     | Capitalize the word
| `Alt + l`     | Make word lowercase
| `Alt + t`     | Move words around
| `Alt + u`     | Make word uppercase
| `Alt + d`     | Delete from current character to the end of the word
| `Ctrl + d`    | Delete character under the cursor
| `Ctrl + h`    | Same as backspace
| `Ctrl + k`    | Delete everything after the cursor
| `Ctrl + u`    | Delete everything before the cursor
| `Ctrl + w`    | Delete the word before the cursor
| `Ctrl + t`    | Swap the last two characters before the cursor
| `Esc + t`     | Swap the last two words before the cursor
| `Tab`	        | Auto- complete files and folder names

## History

| Shortcut      | Action
| :-----------: | ------
| `Alt + <`     | Move to the first line in the history
| `Alt + >`     | Move to the last line in the history
| `Alt + n`     | Search the history forwards non-incremental
| `Alt + p`     | Search the history backwards non-incremental
| `Alt + r`     | Recall command
| `Ctrl + r`    | Search the history backwards. Hit `Ctrl + r` again for switching to other occurrence

## Other

| Shortcut      | Action
| :-----------: | ------
| `Ctrl + c`    | Terminate the command
| `Ctrl + d`    | Exit the current shell
| `Ctrl + l`    | Clear the screen
| `Ctrl + z`    | Puts whatever you are running into a suspended background process. `fg` restores it.
