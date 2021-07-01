# DEBIAN DESKTOP VM DEV EDITION

## Description
This repo contains a fully working linux desktop build in docker.
It uses the nativ docker linux files system without qemu or virtualbox.
U can do some setup in the docker-compose file like choosing the debian, node or php version,
please see the [use](##Use) section for a more detailed instruction.
It also has vim and nvim setup with alot of features like python, js and php editing.
The Desktop can be combined with other services like Mysql or Apache2 via docker-compose.
The default desktop is qtile, wich is a wm, u can also use a default Lxde or Openbox session.
After building an starting the container u can connect to it via any VNC Viewer, 
the default Port is 5901 but can be changed to what ever u want in the docker-compose file.


## Includes
- Lxde (version picked in docker-compose)
- Qtile
- Nvm / Node.js (version picked in docker-compose)
- Php (version picked in docker-compose)
- Rust (broot, sd, procs, ripgrep)
- Python 2 & 3
- Nvim & Plugins
- Flatpak & Snap
- Vnc Server
- LightDM
- Apache2 & Nginx (disabled)

## Use

## todo

- test mounts
- complete the docker compose
- clean up the docker file
- test nvim
- test nvim
- test nvim
- test nvim
- test nvim
- test nvim
- test nvim
- test nvim
- test nvim
- test nvim
