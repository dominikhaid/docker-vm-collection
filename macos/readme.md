# Docker Gib Sur VM

## Description

We used the images from [sickcodes](https://github.com/sickcodes/Docker-OSX.git), they have done an awesome job making BigSur and Catalina run docker.
The compose file defaults to a setup where BigSur is booted with vnc enabled to port 5999. If you ran into any errors pleae visit the sickcodes repo linked above for further instructions.

## Use

1. docker-compose run mac-vm
2. hit return until you see the qemu console
3. type "change vnc password username"
4. inupt vnc password
5. connect to the docker container using the ip of the container and you perferred vnc viewer.
6. click disk util
7. erase the bigger driver
8. close the disk util and hit install
9. to restart the same container again use docker-compose start mac-vm or docker start -ai CONTAINER_ID

**NOTE: if you run docker-compose up or docker-compose run a new container will be created**
