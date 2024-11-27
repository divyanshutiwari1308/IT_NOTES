#!/bin/bash

# Update system and upgrade packages
echo "Updating system packages..."
sudo apt update -y && sudo apt upgrade -y

# Install OpenSSH server if not already installed
echo "Installing OpenSSH server..."
sudo apt install openssh-server -y

# Enable and start the SSH service
echo "Enabling and starting SSH service..."
sudo systemctl enable --now ssh

# Check the SSH service status
echo "Checking SSH service status..."
sudo systemctl status ssh

# Backup the original SSH configuration
echo "Backing up the original sshd_config file..."
sudo cp /etc/ssh/sshd_config /etc/ssh/sshd_config.initial

# Make changes to the SSH configuration file
echo "Modifying /etc/ssh/sshd_config..."
sudo sed -i 's/^#Port 22/Port 6969/' /etc/ssh/sshd_config
sudo sed -i 's/^#PermitRootLogin prohibit-password/PermitRootLogin no/' /etc/ssh/sshd_config
sudo sed -i 's/^#PubkeyAuthentication yes/PubkeyAuthentication yes/' /etc/ssh/sshd_config

# Restart SSH service to apply changes
echo "Restarting SSH service to apply changes..."
sudo systemctl restart ssh

# Final confirmation
echo "SSH has been successfully configured!"
echo "Changes made in /etc/ssh/sshd_config:"
echo "1. Port changed to 6969"
echo "2. Root login disabled (PermitRootLogin no)"
echo "3. Public key authentication enabled (PubkeyAuthentication yes)"
