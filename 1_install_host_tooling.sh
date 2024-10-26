#!/bin/bash
set -euo pipefail



sudo apt install needrestart -y

echo "--- Setting noninteractive and updating repos ---"
export DEBIAN_FRONTEND=noninteractive
echo "\$nrconf{restart} = 'l';" | sudo tee /etc/needrestart/conf.d/90-autorestart.conf > /dev/null
sudo apt-get update

# Install venv
sudo apt install -y python3-venv

# Install net-tools
sudo apt install -y net-tools

# Install snmpwalk
sudo apt install -y snmp

# Install Docker and Compose
echo "--- Installing Docker and ContainerLab ---"
if [ -f "setup" ]; then
    rm -v "setup"
fi


# Check if running Ubuntu
echo "This is not Ubuntu. trying containerlab install"
curl -sL https://containerlab.dev/setup | sudo -E bash -s "all"




# Start docker
sudo systemctl start docker

# Get the current username using whoami
current_user=$(whoami)

# Check if the current user is in the docker group
if groups $current_user | grep -q "\bdocker\b"; then
    echo "User $current_user is in the docker group."
else
    echo "User $current_user is NOT in the docker group."
	sudo adduser $current_user docker
fi

echo
echo "--- Creating Docker Network ---"
echo

docker network create --driver=bridge --subnet=${WORKSHOP_SUBNET} autocon-workshop
