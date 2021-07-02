#! /bin/bash
shopt -s nullglob dotglob

username="dominik"
password="dom53361."
apt=apt-get
rapt=echo $password | sudo -S apt install -y



##
#USER
##
userSetup() {

  echo "deb http://deb.debian.org/debian/ bullseye main non-free" | tee -a /etc/apt/sources.list
  echo "deb-src http://deb.debian.org/debian/ bullseye main non-free"  | tee -a /etc/apt/sources.lists
  #echo "deb http://security.debian.org/debian-security bullseye-security main"  | tee -a /etc/apt/sources.list

  ## Update System
  $apt update -y
  $apt upgrade -y
  $apt install -y locales

  echo "LC_ALL=en_US.UTF-8" >> /etc/environment
  echo "en_US.UTF-8 UTF-8" >> /etc/locale.gen
  echo "LANG=en_US.UTF-8" > /etc/locale.conf
  locale-gen en_US.UTF-8
 
  $apt update -y && $apt upgrade -y && $apt install -y \
    wget \
    ssh \
    sudo \
    htop \
    git \
    openssh-server \
    build-essential \
    cmake
  
  useradd -m $username
  echo "$username:$password" | chpasswd $username
  usermod -aG sudo $username
}

desktop() { 
  ## Desktop
  $apt install  -yq lxde
}

tools() {
  ## Bae Tools
  sudo -u $username -H sh -c "echo $password | sudo -S apt install -y curl exa kitty git gnome-keyring python3-pip ripgrep ufw zsh nginx apache2 lsb-release ca-certificates apt-transport-https software-properties-common tightvncserver vim rofi fzf exuberant-ctags"
  }

##
#Rust
##
rust() {

  sudo -i -u $username bash << EOF
    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
    source /home/$username/.cargo/env
    cargo install sd
  
EOF

}

##
#UFW
##
ufw() {
sudo -i -u $username bash << EOF
 echo $password | sudo ufw enable
 echo $password | sudo ufw allow 22
 echo $password | sudo ufw allow 80
 echo $password | sudo ufw allow 443
 echo $password | sudo ufw allow 5900
 echo $password | sudo ufw allow 5901

EOF
}

##
# Python
##
python() {
  sudo -i -u $username bash << EOF
  sudo rm -R  /home/$username/.cache/pip
  pip install 'xcffib>=0.5.0'
  pip install --no-deps --ignore-installed cairocffi 
  pip install qtile

EOF
}

##
# Terminal
##
terminal() {
  sudo -i -u $username bash << EOF
  curl sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
  curl sh -c "$(curl -fsSL https://starship.rs/install.sh)"

EOF
}

##
# Node
##
node() {
  sudo -i -u $username bash << EOF
  curl https://raw.githubusercontent.com/creationix/nvm/master/install.sh | bash 
  source ~/.profile
  export NVM_DIR="/home/$username/.config/nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"
  nvm install node lts

EOF
}

##
# After Install Scripts
##
postInstall() {
  echo 2 | update-alternatives --config x-terminal-emulator
  systemctl disable apache2
  systemctl disable nginx
  sudo -i -u $username bash << EOF
  git clone https://github.com/dominikhaid/dotfiles-public.git /home/$username/dotfiles
  sudo rm -R /home/$username/dotfiles/.git
  cp -r /home/$username/dotfiles/. /home/$username
  sudo rm -R /home/$username/dotfiles
  ln -s /home/dominik/nvim.appimage /home/dominik/.local/bin/nvim
  sudo chmod a+x /home/$username/nvim.appimage
EOF
}

##
# Php
##
php() {
  sudo -i -u $username bash << EOF
  echo "deb https://packages.sury.org/php/ $(lsb_release -sc) main" | sudo tee /etc/apt/sources.list.d/sury-php.list
  wget -qO - https://packages.sury.org/php/apt.gpg | sudo apt-key add -
  echo $password | sudo -S apt update -y
  echo $password | sudo -S apt install -y php8.0-{mysql,cli,common,imap,ldap,xml,fpm,curl,mbstring,zip}
  
EOF
}

##
# Fonts
##
fonts() {
  sudo -i -u $username bash << EOF
  cd
  git clone https://github.com/ryanoasis/nerd-fonts
  cd nerd-font 
  ./install.sh
EOF
}

userSetup
#desktop
#tools
#rust
#ufw
#python
#terminal
#node
#php
#fonts
#postInstall 

#write the qtile desktop 
#systemd
#volumes
#kitty gpu
