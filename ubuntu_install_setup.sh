#!/bin/bash

### Functions ###
program_exist () {
    which "$1" > /dev/null
}

path_exist () {
    [ -d "$1" ]
}

file_exist () {
    [ -f "$1" ]
}

### Script ###
cd "$(dirname "$0")"

echo -e "\n" | sudo add-apt-repository ppa:teejee2008/ppa

sudo apt-get update
sudo apt-get -y install neovim thunderbird screen nmap net-tools zsh openssh-server gvfs-bin i3 py3status fish playerctl python3-pip clang-format virtualbox bluez-tools expect --fix-missing
sudo apt-get -y upgrade
sudo apt-get -y autoremove

sudo snap install libreoffice
sudo snap install slack --classic
sudo snap install spotify
sudo snap install teams-for-linux
sudo snap install universal-ctags
sudo snap install vlc

# Copy files
# TODO(joha): Copy only once
cp -r Documents/ ~/Documents/
cp -r Pictures/ ~/Pictures/
cp -r Public/ ~/Public/

# Neovim
cp .vimrc ~/.config/nvim/init.vim
git clone https://github.com/VundleVim/Vundle.vim.git ~/.config/nvim/bundle/Vundle.vim

# Setup SSH to this computer
sudo ufw allow ssh

# TODO(joha): Define which sections below to install, make them optional. Maybe programs above as well.

# Certificate for git
if ! file_exist /usr/local/share/ca-certificates/bitbucket-sto.crt
then
    gio mount smb://172.16.5.1/users$/$(users)
    cp $XDG_RUNTIME_DIR/gvfs/$(ls -1 $XDG_RUNTIME_DIR/gvfs/ | grep smb)/$(users)/bit* ~/bitbucket-sto.crt
    sudo mv ~/bitbucket-sto.crt /usr/local/share/ca-certificates/bitbucket-sto.crt
    sudo update-ca-certificates
    gio mount smb://172.16.5.1/users$/$(users) -u
fi

# Install vpn --- https://uci.service-now.com/kb_view.do?sysparm_article=KB0010201
if ! program_exist vpn
then
    sudo apt-get -y install libpangox-1.0-0 libgtk2.0-0:i386
    tar -xvzf vpn/anyconnect-linux64-4.6.02074-predeploy-k9.tar.gz -C vpn/ > /dev/null 2>&1
    cd vpn/anyconnect-linux64-4.6.02074/vpn
    echo -e "y\n" | sudo ./vpn_install.sh
    echo "export PATH=$PATH:/opt/cisco/anyconnect/bin/" >> ~/.bashrc
    cd - > /dev/null 2>&1
fi

# Install chrome
if ! program_exist google-chrome
then
    wget -P ~/Downloads/ https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
    sudo apt-get install ~/Downloads/google-chrome-stable_current_amd64.deb
    rm ~/Downloads/google-chrome-stable_current_amd64.deb
fi

# ZSH
if ! program_exist zsh
then
    cp zsh/.* ~/ > /dev/null 2>&1
    chsh -s $(which zsh)
fi

# fish
if ! program_exist fish
then
    cp -r .config/fish/ ~/.config/fish/
    sudo chsh -s $(which fish)
    set -g -x fish_greeting ''
fi

# FIJI/ImageJ
if ! program_exist fiji
then
    wget -P ~/Downloads/ https://downloads.imagej.net/fiji/latest/fiji-linux64.zip
    mkdir -p ~/programs
    unzip ~/Downloads/fiji-linux64.zip -d ~/programs/ > /dev/null 2>&1
    sudo rm /usr/bin/fiji > /dev/null 2>&1
    sudo ln -s ~/programs/Fiji.app/ImageJ-linux64 /usr/bin/fiji
    #sudo chmod +rwx ~/programs/Fiji.app/ImageJ-linux64
    rm ~/Downloads/fiji-linux64.zip
fi

# Install Docker
if ! program_exist docker
then
    sudo apt-get install apt-transport-https ca-certificates curl gnupg-agent software-properties-common --fix-missing
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
    # Docker does not yet support Ubuntu 20.04 LTS
    #sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
    sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu bionic stable"
    sudo apt-get update
    sudo apt-get install docker-ce docker-ce-cli containerd.io -y
    sudo usermod -aG docker $(users)
fi

# Install i3
if ! path_exist ~/.config/i3status/
then
    cp -r .config/i3/ ~/.config/i3/
    cp -r .config/i3status/ ~/.config/i3status/
fi

