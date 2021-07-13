# Docker Debian Desktop - DEV Edition

## Description

This repo contains a fully working linux desktop build in docker.
It uses the nativ docker linux files system without qemu or virtualbox.
U can do some setup in the docker-compose file like choosing the debian, node or php version,
please see the [use](#Use) section for a more detailed instruction.
It also has vim and nvim setup with alot of features like python, js and php editing.
The default desktop is qtile, wich is a wm, u can also use a default Lxde or Openbox session.
After building an starting the container u can connect to it via any VNC Viewer.

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

> docke>  run -it -v /sys/fs/cgroup:/sys/fs/cgroup -v /sys/fs/fuse:/sys/fs/fuse  --tmpfs /tmp --tmpfs /run  --tmpfs /run/lock -p 5901:5900 -p 80:80 --cgroupns=host debian-vm
 


## TODO

- snap and flatpak require a privileged container
- appimages
- add rdp
