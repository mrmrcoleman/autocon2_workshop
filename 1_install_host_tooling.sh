#!/bin/bash
set -euo pipefail

# Check if all required environment variables are set
REQUIRED_VARS=("WORKSHOP_SUBNET")

for var in "${REQUIRED_VARS[@]}"; do
  if [ -z "${!var:-}" ]; then
    echo "Error: Required environment variable '$var' is not set."
    exit 0
  fi
done

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

# Install Docker
echo "--- Installing Docker ---"

sudo apt install -y apt-transport-https ca-certificates curl software-properties-common
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | gpg --dearmor | sudo install -o root -g root /dev/stdin /usr/share/keyrings/docker-archive-keyring.gpg
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt update
sudo apt install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin


# Install ContainerLab
echo "--- Installing ContainerLab ---"

curl -sL https://containerlab.dev/setup | sudo -E bash -s "install-containerlab"

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
