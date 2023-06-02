#!/bin/sh

# Script to install Powershell (Ubuntu)

usage() {
    cat <<EOM
    Usage:
    $(basename $0) <powershellModules>
EOM
    exit 0
}

[ -z $1 ] && { usage; }

#### Install Powershell ####

# Update the list of packages
sudo apt-get update
# Install pre-requisite packages.
sudo apt-get install -y wget apt-transport-https software-properties-common
# Download the Microsoft repository GPG keys
wget -q "https://packages.microsoft.com/config/ubuntu/$(lsb_release -rs)/packages-microsoft-prod.deb"
# Register the Microsoft repository GPG keys
sudo dpkg -i packages-microsoft-prod.deb
# Delete repository file
rm packages-microsoft-prod.deb
# Update the list of products
sudo apt-get update
# Install PowerShell
sudo apt-get install -y powershell

# Install PowerShell Modules
pwsh -Command Install-Module -Scope AllUsers -Force $1