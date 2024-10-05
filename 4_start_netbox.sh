#!/bin/bash
set -euo pipefail

# Starting network
echo
echo "--- Starting NetBox ---"
echo

# Clone netbox-docker
git clone -b release https://github.com/netbox-community/netbox-docker.git
pushd netbox-docker

# Create plugin files
cat <<EOF > plugin_requirements.txt
slurpit_netbox
EOF

cat <<EOF > Dockerfile-Plugins
FROM netboxcommunity/netbox:latest

COPY ./plugin_requirements.txt /opt/netbox/
RUN /opt/netbox/venv/bin/pip install  --no-warn-script-location -r /opt/netbox/plugin_requirements.txt

# These lines are only required if your plugin has its own static files.
#COPY configuration/configuration.py /etc/netbox/config/configuration.py
#COPY configuration/plugins.py /etc/netbox/config/plugins.py
#RUN SECRET_KEY="dummydummydummydummydummydummydummydummydummydummy" /opt/netbox/venv/bin/python /opt/netbox/netbox/manage.py collectstatic --no-input
EOF

cat <<EOF > docker-compose.override.yml
services:
  netbox:
    image: netbox:latest-plugins
    pull_policy: never
    ports:
      - 8001:8080
    build:
      context: .
      dockerfile: Dockerfile-Plugins
  netbox-worker:
    image: netbox:latest-plugins
    pull_policy: never
  netbox-housekeeping:
    image: netbox:latest-plugins
    pull_policy: never
EOF

# Add the Slurpit plugin to configuration.py
cat <<EOF > configuration/plugins.py
PLUGINS = ["slurpit_netbox"]
EOF

# Build NetBox
docker compose build --no-cache

# Start NetBox
docker compose up -d

popd


# Check the static files section in Dockerfile-Plugins to see if they are necessary