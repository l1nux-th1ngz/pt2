#!/bin/bash

# Add GRUB_HIDDEN_TIMEOUT=0 and update GRUB_TIMEOUT
echo "Updating GRUB configuration..."
sudo sed -i '/^GRUB_TIMEOUT=/s/=.*/=0/' /etc/default/grub
sudo grep -qxF 'GRUB_HIDDEN_TIMEOUT=0' /etc/default/grub || echo 'GRUB_HIDDEN_TIMEOUT=0' | sudo tee -a /etc/default/grub

# Update GRUB
echo "Updating GRUB bootloader..."
sudo update-grub

echo "GRUB update complete!"
