#!/bin/bash

# Move and make the Python script executable
sudo mv whichSystem.py /usr/local/bin/whichSystem.py
sudo chmod +x /usr/local/bin/whichSystem.py

# Prompt the user to enter an IP address
read -p "Enter the IP address to check: " ip_address

# Run the Python script with the entered IP address
python3 /usr/local/bin/whichSystem.py "$ip_address"
