#!/bin/bash

# Update package list
sudo apt-get update

# List of packages to install
packages=(
    bookworm-backports
    linux-image-amd64/bookworm-backports
    linux-headers-amd64/bookworm-backports
    firmware-linux
    bc 
    bison
    dh-make 
    pbuilder
    build-essential
    fakeroot 
    flex 
    libelf-dev 
    libncurses5-dev 
    libssl-dev
    autoconf
    libparse-debcontrol-perl
    automake
    autopoint 
    autotools-dev
    debhelper
    dh-autoreconf
    dpkg-dev
    devscripts
    dh-strip-nondeterminism
    dwz 
    gettext
    intltool-debian 
    libarchive-zip-perl
    libfl-dev
    libdebhelper-perl
    libfile-stripnondeterminism-perl
    libsub-override-perl
    libtool 
    po-debconf
)

# Install packages
for package in "${packages[@]}"; do
    sudo apt-get -y install "$package"
done

echo "-------------------------------------------------------------------------------"
echo ""

# Install specific packages from bookworm-backports
sudo apt-get -y install -t bookworm-backports linux-image-amd64 linux-headers-amd64 firmware-linux

# Wait for processes to complete
wait

# Update package list again
sudo apt-get update

echo "Setup completed. All specified packages installed."
