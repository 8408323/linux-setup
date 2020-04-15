#!/bin/bash

### Functions ###
program_exists () {
    which "$1" > /dev/null
}

### Script ###
cd "$(dirname "$0")"

echo -e "\n" | sudo add-apt-repository ppa:teejee2008/ppa

sudo apt-get update
sudo apt-get -y install neovim thunderbird screen nmap net-tools zsh openssh-server --fix-missing
sudo apt-get -y upgrade
sudo apt-get -y autoremove
sudo snap install slack --classic
sudo snap install teams-for-linux
sudo snap install vlc
sudo snap install libreoffice

# Setup SSH to this computer
sudo ufw allow ssh

# TODO(joha): Define which sections below to install, make them optional. Maybe programs above as well.

# Install vpn --- https://uci.service-now.com/kb_view.do?sysparm_article=KB0010201
if ! program_exists vpn
then
    sudo apt-get -y install libpangox-1.0-0 libgtk2.0-0:i386
    tar -xvzf vpn/anyconnect-linux64-4.6.02074-predeploy-k9.tar.gz -C vpn/ > /dev/null 2>&1
    cd vpn/anyconnect-linux64-4.6.02074/vpn
    echo -e "y\n" | sudo ./vpn_install.sh
    echo "export PATH=$PATH:/opt/cisco/anyconnect/bin/" >> ~/.bashrc
    cd - > /dev/null 2>&1
fi

# Install chrome
if ! program_exists google-chrome
then
    wget -P ~/Downloads/ https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
    sudo apt-get install ~/Downloads/google-chrome-stable_current_amd64.deb
    rm ~/Downloads/google-chrome-stable_current_amd64.deb
fi

# ZSH
if ! program_exists zsh
then
    cp zsh/.* ~/ > /dev/null 2>&1
    chsh -s $(which zsh)
fi

# FIJI/ImageJ
if ! program_exists fiji
then
    wget -P ~/Downloads/ https://downloads.imagej.net/fiji/latest/fiji-linux64.zip
    mkdir -p ~/programs
    unzip ~/Downloads/fiji-linux64.zip -d ~/programs/ > /dev/null 2>&1
    sudo rm /usr/bin/fiji > /dev/null 2>&1
    sudo ln -s ~/programs/Fiji.app/ImageJ-linux64 /usr/bin/fiji
    #sudo chmod +rwx ~/programs/Fiji.app/ImageJ-linux64
    rm ~/Downloads/fiji-linux64.zip
fi


# Install i3

