#!/bin/bash

# Install required packages
sudo apt-get -y install lsb-release 
sudo apt-get -y install fasttrack-archive-keyring

# Update package lists
sudo apt-get update

# Update sources.list with the new repositories
sudo bash -c 'cat > /etc/apt/sources.list <<EOF
deb https://fasttrack.debian.net/debian-fasttrack/ bookworm-fasttrack main contrib non-free non-free-firmware
deb https://ftp.debian.org/debian/ bookworm contrib main non-free non-free-firmware
deb https://ftp.debian.org/debian/ bookworm-updates contrib main non-free non-free-firmware
deb https://ftp.debian.org/debian/ bookworm-proposed-updates contrib main non-free non-free-firmware
deb https://ftp.debian.org/debian/ bookworm-backports contrib main non-free non-free-firmware
deb https://security.debian.org/debian-security/ bookworm-security contrib main non-free non-free-firmware
EOF'

# Update package lists
sudo apt-get update

# Upgrade packages
sudo apt-get -y upgrade

echo "System upgrade completed with new repositories added."
