#!/bin/bash

# Move the script to the BSPWM configuration directory
mv external_rules.py ~/.config/bspwm/external_rules.py

# Make the script executable
chmod +x ~/.config/bspwm/external_rules.py

echo "external_rules.py has been moved and made executable."
