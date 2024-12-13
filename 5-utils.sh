#!/bin/bash

# Update package list
sudo apt-get update

# List of packages to install
packages=(
    picom
    picom-conf
    fontconfig
    fontconfig-config
    yad
    scrot
    feh
    ffmpeg
    gir1.2-gtk-3.0
    python-gtk2
    gcc 
    make 
    xcb 
    libxcb-util0-dev 
    libxcb-ewmh-dev 
    libxcb-randr0-dev 
    libxcb-icccm4-dev 
    libxcb-keysyms1-dev 
    libxcb-xinerama0-dev 
    libxcb-ewmh2
    vlc
    mpv
    ncmpcpp
    mpd
    mpc
    gvfs
    gvfs-backends 
    avahi-daemon
    acpid
)

# Install packages
for package in "${packages[@]}"; do
    sudo apt-get -y install "$package"
done

# Enable services to start on boot
sudo systemctl enable avahi-daemon
sudo systemctl enable acpid

# Start the services immediately
sudo systemctl start avahi-daemon
sudo systemctl start acpid

echo "Setup completed. All specified packages installed and services enabled."
