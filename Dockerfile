FROM debian:bullseye
#MAKE SORUCE AVAILABE CHANGE SH TO BASH
RUN rm /bin/sh && ln -s /bin/bash /bin/sh

ENV container docker
ENV LC_ALL C
ENV DEBIAN_FRONTEND noninteractive

USER root
WORKDIR /root

##
#PORTS
##
EXPOSE 5900

##
# ENABLE SYSTEMCTL
##
RUN set -x

RUN apt-get update -y \
    && apt-get install --no-install-recommends -y systemd \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* \
    && rm -f /var/run/nologin

RUN rm -f /lib/systemd/system/multi-user.target.wants/* \
    /etc/systemd/system/*.wants/* \
    /lib/systemd/system/local-fs.target.wants/* \
    /lib/systemd/system/sockets.target.wants/*udev* \
    /lib/systemd/system/sockets.target.wants/*initctl* \
    /lib/systemd/system/sysinit.target.wants/systemd-tmpfiles-setup* \
    /lib/systemd/system/systemd-update-utmp*

##
# SETUP BASE SYSTEM
#
RUN  echo "deb http://deb.debian.org/debian/ bullseye main non-free" | tee -a /etc/apt/sources.list \
 &  echo "deb-src http://deb.debian.org/debian/ bullseye main non-free"  | tee -a /etc/apt/sources.lists

RUN apt update -y && apt upgrade -y && apt-get install -y locales

RUN  echo "LC_ALL=en_US.UTF-8" >> /etc/environment \
     & echo "en_US.UTF-8 UTF-8" >> /etc/locale.gen \
     & echo "LANG=en_US.UTF-8" > /etc/locale.conf \
     &  locale-gen en_US.UTF-8

RUN apt update -y && apt upgrade -y && apt install -y \
    wget \
    ssh \
    sudo \
    htop \
    git \
    flatpak \
    snapd \
    xinit \
    fuse \
    squashfuse \
    openssh-server \
    build-essential \
    cmake \
    lxde \
    x11vnc \
    dbus \
    libnotify-dev \
    python3-xcffib \
    python3-cairocffi \
    iputils-ping \
    python \
    dbus-user-session \
    systemd \
    libsystemd-dev \
    x11-apps \
    net-tools \
    libpulse-dev \
    exa \
    vim-nox \
    libffi-dev \
    libxcb-render0-dev \
    xvfb \
    ninja-build \
    gettext \
    libtool \
    libtool-bin \
    autoconf \
    automake \
    cmake \
    g++ \
    pkg-config \
    unzip \
    accountsservice



##
# Copy Files
##

COPY ./vnc/x11vnc.service /etc/systemd/system/x11vnc.service
COPY ./vnc/xserverrc /etc/X11/xinit/xserverrc
COPY ./vnc/xstartup /root/.vnc/xstartup
COPY ./lightdm/lightdm.conf /etc/lightdm/lightdm.conf
COPY ./vnc/tail /etc/resolvconf/resolv.conf.d/tail
COPY ./qtile/qtile.desktop /usr/share/xsessions/qtile.desktop



##
# ADD USER
#
ARG username=dominik
ARG password=dom53361.

RUN  useradd -m $username \
  && echo "$username:$password" | chpasswd $username \
  && usermod -aG sudo $username


##
# User Config
#
USER $username
RUN  echo $password | sudo -S  apt install -y \
  curl \
  kitty \
  git \
  gnome-keyring \
  python3-pip \
  ripgrep \
  fonts-firacode \
  zsh \
  nginx \
  apache2 \
  lsb-release \
  ca-certificates \
  apt-transport-https \
  software-properties-common \
  tightvncserver \
  vim \
  rofi \
  fzf \
  tree \
  vifm \
  gimp \
  inkscape \
  imagemagick \
  cowsay \
  bat \
  fortune \
  pasystray \
  nitrogen \
  exuberant-ctags

##
# Rust
#

RUN echo $password | sudo -S su $username -c "curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y \
      && source /home/$username/.cargo/env \
      && cargo install sd \
      && cargo install broot \
      && cargo install procs"

  
##
# NVIM
##

COPY ./user-config/ /home/$username/
COPY ./vnc/xstartup /home/$username/.vnc/xstartup
USER root
RUN  chown $username:$username -R /home/$username/
USER $username
RUN echo $password | sudo -S su $username -c "git clone https://github.com/neovim/neovim /home/$username/neovim \
      && cd /home/$username/neovim \
      && make CMAKE_EXTRA_FLAGS='-DCMAKE_INSTALL_PREFIX=/home/$username/neovim' \
      && make install"

RUN echo $password | sudo -S su $username -c "curl -LSso ~/.vim/autoload/pathogen.vim https://tpo.pe/pathogen.vim \
      && /home/$username/neovim/build/bin/nvim +'PlugInstall --headless --sync' +'PlugUpdate' +qa"

##
# Python
##

#RUN echo $password | sudo -S -u $username  rm -R  /home/$username/.cache/pip
RUN pip3 install 'xcffib>=0.5.0' \
 & pip3 install --no-deps --ignore-installed cairocffi \
 & pip3 install dbus-next \
 & pip3 install --upgrade psutil \
 & pip3 install qtile

#RUN echo $password | sudo -S su $username -c "cd /home/$username &&  git clone git://github.com/qtile/qtile.git"

##
# ZSH
#

RUN echo $password | sudo -S su $username -c "cd /home/$usernam  \
      && curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh | bash"

RUN git clone https://github.com/jeffreytse/zsh-vi-mode /home/$username/.oh-my-zsh/custom/plugins/zsh-vi-mode

##
#NVM and NODE
##
ENV NVM_DIR /home/$username/.nvm
ENV NODE_VERSION 15

RUN  echo $password | sudo -S su $username -c "curl https://raw.githubusercontent.com/creationix/nvm/master/install.sh | bash"

RUN echo $password | sudo -S su $username -c "source $NVM_DIR/nvm.sh \
    && nvm install $NODE_VERSION \
    && nvm alias default $NODE_VERSION \
    && nvm use default"


USER root
RUN sh -c "$(curl -fsSL https://starship.rs/install.sh)" -- --yes


##
#PHP
##
RUN  echo "deb https://packages.sury.org/php/ $(lsb_release -sc) main" | tee /etc/apt/sources.list.d/sury-php.list && \
       wget -qO - https://packages.sury.org/php/apt.gpg | apt-key add - 

RUN apt update -y && \
      apt install -y php8.0-{mysql,cli,common,imap,ldap,xml,fpm,curl,mbstring,zip}


##
# System and Systemd
#
RUN systemctl disable apache2 \
      && systemctl disable  connman.service \
      && systemctl disable nginx \
      &&systemctl enable x11vnc.service\
      && ln -s /run /var/run
RUN echo 1 | update-alternatives --config x-terminal-emulator 
RUN echo $password | sudo -S su $username  -c "chsh -s $(which bash)"

RUN mkdir -p /etc/systemd/system/systemd-logind.service.d && touch /etc/systemd/system/systemd-logind.service.d/override.conf
RUN printf "[Service]\nProtectHome=no" | tee /etc/systemd/system/systemd-logind.service.d/override.conf
RUN apt-get update -y && dpkg --configure -a && apt-get dist-upgrade -y && apt-get -f -y install

RUN ln -s /home/$username/.local/bin/qtile /usr/bin/qtile

##
#Volumes
#
VOLUME [ "/sys/fs/cgroup" ]

CMD ["/lib/systemd/systemd"]

## CREATE A NEW CONTAINER
#docker run -it -v /sys/fs/cgroup:/sys/fs/cgroup -v /sys/fs/fuse:/sys/fs/fuse  --tmpfs /tmp --tmpfs /run  --tmpfs /run/lock -p 5901:5900 -p 80:80 --cgroupns=host debian-vm
