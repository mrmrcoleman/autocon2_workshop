#!/bin/bash
set -euo pipefail

# Check if all required environment variables are set
REQUIRED_VARS=("WORKSHOP_SUBNET")

for var in "${REQUIRED_VARS[@]}"; do
  if [ -z "${!var:-}" ]; then
    echo "Error: Required environment variable '$var' is not set."
    exit 1
  fi
done

# Detect the package manager (apt or yum/dnf)
if command -v apt &> /dev/null; then
    PM="apt"
    INSTALL_CMD="sudo apt update && sudo apt install -y"
elif command -v yum &> /dev/null || command -v dnf &> /dev/null; then
    PM=$(command -v dnf || echo yum)  # Use dnf if available, fallback to yum
    INSTALL_CMD="sudo $PM install -y"
else
    echo "Unsupported package manager. Only apt, yum, and dnf are supported."
    exit 1
fi

echo "--- Running setup for Linux ---"

# Install dependencies
if [[ $PM == "apt" ]]; then
    sudo apt update
fi
$INSTALL_CMD python3-venv net-tools snmp curl ca-certificates

# Install Docker
echo "--- Installing Docker ---"
if [[ $PM == "apt" ]]; then
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | gpg --dearmor | sudo tee /usr/share/keyrings/docker-archive-keyring.gpg > /dev/null
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
    sudo apt update
    $INSTALL_CMD docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
else
    sudo $PM install -y yum-utils
    sudo yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo
    sudo $PM install -y docker-ce docker-ce-cli containerd.io docker-compose-plugin
fi

# Start Docker
sudo systemctl enable docker
sudo systemctl start docker

# Install ContainerLab
echo "--- Installing ContainerLab ---"
curl -sL https://containerlab.dev/install.sh | sudo bash

# Add the current user to the Docker group
current_user=$(whoami)
if ! groups "$current_user" | grep -q "\bdocker\b"; then
    echo "Adding user $current_user to the docker group."
    sudo usermod -aG docker "$current_user"
    echo "Please log out and back in for the group change to take effect."
fi

echo "--- Creating Docker Network ---"
docker network create --driver=bridge --subnet="${WORKSHOP_SUBNET}" autocon-workshop

echo "--- Setup Complete ---"