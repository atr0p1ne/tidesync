TideSync (AUR package)

WORK IN PROGRESS

This program let you synchronize your defined directories to server via rsync.

Its written in Fish.

1. config.toml

   - Main configuration file, default is stored in /usr/share/tidesync/config.toml
   - When you run tidesync for first time it checked ~/.config/tidesync/config.toml
     and copy default there.
   - You have to modify that before use, things like user and server and directories to sync.
