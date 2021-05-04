#!/bin/sh

# Script to install an azure hybrid worker (Ubuntu 18.04)

usage() {
    cat <<EOM
    Usage:
    $(basename $0) <powershellModules> <logAnalyticsworkspaceId> <automationSharedKey> <hybridGroupName> <automationEndpoint>

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
wget -q https://packages.microsoft.com/config/ubuntu/18.04/packages-microsoft-prod.deb
# Register the Microsoft repository GPG keys
sudo dpkg -i packages-microsoft-prod.deb
# Delete repository file
rm packages-microsoft-prod.deb
# Update the list of products
sudo apt-get update
# Enable the "universe" repositories
sudo add-apt-repository universe
# Install PowerShell
sudo apt-get install -y powershell

# Install PowerShell Modules
pwsh -Command Install-Module -Scope AllUsers -Force $1

#### Register Hybrid Worker ####

# Registration
sudo python /opt/microsoft/omsconfig/modules/nxOMSAutomationWorker/DSCResources/MSFT_nxOMSAutomationWorkerResource/automationworker/scripts/onboarding.py --register -w $2 -k $3 -g $4 -e $5
# Disable signature validation
sudo python /opt/microsoft/omsconfig/modules/nxOMSAutomationWorker/DSCResources/MSFT_nxOMSAutomationWorkerResource/automationworker/scripts/require_runbook_signature.py --false $2