#!/bin/bash

# Install netselect-apt
sudo apt-get -y install netselect-apt

# U1
sudo apt-get update -eany

# Use netselect-apt to find the fastest Debian mirror and create a sources.list
sudo netselect-apt


# Update package list
sudo apt-get update -y

echo "netselect-apt installed, fastest mirror selected, and package list updated."
