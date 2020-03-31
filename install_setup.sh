#!/bin/bash

cd "$(dirname "$0")"

sudo apt-get update >/dev/null
sudo apt-get -y install neovim thunderbird

# Install vpn --- https://uci.service-now.com/kb_view.do?sysparm_article=KB0010201
sudo apt-get -y install libpangox-1.0-0 libgtk2.0-0:i386
tar -xvzf vpn/anyconnect-linux64-4.6.02074-predeploy-k9.tar.gz -C vpn/ >/dev/null 2>&1
cd vpn/anyconnect-linux64-4.6.02074/vpn
echo -e "y\n" | sudo ./vpn_install.sh
echo "export PATH=$PATH:/opt/cisco/anyconnect/bin/" >> ~/.bashrc

# Install chrome
wget -P ~/Downloads/ https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
sudo apt-get install ~/Downloads/google-chrome-stable_current_amd64.deb
rm ~/Downloads/google-chrome-stable_current_amd64.deb

# Install i3

cd - >/dev/null 2>&1
