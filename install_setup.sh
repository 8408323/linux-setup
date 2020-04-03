#!/bin/bash

### Functions ###
program_exists () {
    which "$1" > /dev/null
}

### Script ###
cd "$(dirname "$0")"

sudo apt-get update >/dev/null
sudo apt-get -y install neovim thunderbird screen zsh --fix-missing

# Install vpn --- https://uci.service-now.com/kb_view.do?sysparm_article=KB0010201
if ! program_exists vpn
then
    sudo apt-get -y install libpangox-1.0-0 libgtk2.0-0:i386
    tar -xvzf vpn/anyconnect-linux64-4.6.02074-predeploy-k9.tar.gz -C vpn/ >/dev/null 2>&1
    cd vpn/anyconnect-linux64-4.6.02074/vpn
    echo -e "y\n" | sudo ./vpn_install.sh
    echo "export PATH=$PATH:/opt/cisco/anyconnect/bin/" >> ~/.bashrc
    cd - >/dev/null 2>&1
fi

# Install chrome
if ! program_exists google-chrome
then
    wget -P ~/Downloads/ https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
    sudo apt-get install ~/Downloads/google-chrome-stable_current_amd64.deb
    rm ~/Downloads/google-chrome-stable_current_amd64.deb
fi

# ZSH
echo $(pwd)
if ! program_exists zsh
then
    cp zsh/.* ~/ >/dev/null 2>&1
    chsh -s $(which zsh)
fi

# Install i3

