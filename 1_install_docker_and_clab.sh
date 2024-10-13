# NOTE: This script has only been tested on Ubuntu 22.04 LTS
#!/bin/bash
set -euo pipefail

echo "--- Setting noninteractive and updating repos ---"
export DEBIAN_FRONTEND=noninteractive
echo "\$nrconf{restart} = 'l';" > /etc/needrestart/conf.d/90-autorestart.conf
apt-get update

# Install venv
apt install -y python3.12-venv

# Install Docker and Compose
echo "--- Installing Docker and ContainerLab ---"
if [ -f "setup" ]; then
    rm -v "setup"
fi

wget https://containerlab.dev/setup
sed -i 's/^DOCKER_VERSION="[^"]*"/DOCKER_VERSION="5:27.3.1-1~ubuntu.24.10~oracular"/' setup
cat setup | sudo bash -s "all"

# Start docker
systemctl start docker

echo
echo "--- Creating Docker Network ---"
echo

docker network create --driver=bridge --subnet=${WORKSHOP_SUBNET} autocon-workshop