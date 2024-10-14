#!/bin/bash
set -euo pipefail

# Check if all required environment variables are set
REQUIRED_VARS=("MY_EXTERNAL_IP" "ICINGA_PORT" "SLURPIT_PORT" "NETBOX_PORT" "NETPICKER_PORT")

for var in "${REQUIRED_VARS[@]}"; do
  if [ -z "${!var:-}" ]; then
    echo "Error: Required environment variable '$var' is not set."
    exit 0
  fi
done

echo
echo "--- Cloning Icinga2 ---"
echo

git clone -b master https://github.com/davekempe/icinga2-docker-stack/
pushd icinga2-docker-stack

echo
echo "--- Writing configuration ---"
echo

echo "MYSQL_ROOT_PASSWORD=12345678" > secrets_sql.env

# Remove SSL/TLS
sed -i '/4443:443/d' docker-compose.yml

# Update the outside port
sed -i 's/8080:80/${ICINGA_PORT}:80/' docker-compose.yml

# Uncomment the credentials
sed -i 's/^ *#- ICINGAWEB2_ADMIN_USER=icingaadmin/      - ICINGAWEB2_ADMIN_USER=icingaadmin/' docker-compose.yml
sed -i 's/^ *#- ICINGAWEB2_ADMIN_PASS=icinga/      - ICINGAWEB2_ADMIN_PASS=icinga/' docker-compose.yml

echo
echo "--- Starting Icinga2 ---"
echo

docker compose up -d

echo
echo "--- Configuring Icinga2 ---"
echo

# Icinga2 configuration files
HOSTS_CONF="data/icinga/etc/icinga2/conf.d/hosts.conf"
SERVICES_CONF="data/icinga/etc/icinga2/conf.d/services.conf"

TIMEOUT=10
SECONDS_PASSED=0

# Wait for the files to be written back to the host mount
while [[ ! -f "$HOSTS_CONF" || ! -f "$SERVICES_CONF" ]]; do
    # Check if the timeout has been reached
    if [ $SECONDS_PASSED -ge $TIMEOUT ]; then
        echo "Timeout expired. One or both files are still missing."
        exit 1
    fi
    
    # Wait for 1 second
    sleep 1
    SECONDS_PASSED=$((SECONDS_PASSED + 1))
    
    echo "Waiting for Icinga2 configuration files to appear in host mount... $SECONDS_PASSED seconds passed."
done

echo "Both files exist. Continuing..."

# Workshop host
cat <<EOL >> $HOSTS_CONF

object Host "autocon-host" {
    import "generic-host"          # Inherit from a predefined host template
    address = "${MY_EXTERNAL_IP}"    # IP address of the Netpicker frontend
    vars.os = "Linux"              # Custom variable (if relevant)
}
EOL

# Services
cat <<EOL >> $SERVICES_CONF

# HTTP Service check for Slurp'it
object Service "Slurp'it" {
    host_name = "autocon-host"
    check_command = "http"
    vars.http_address = "${MY_EXTERNAL_IP}"  # IP address from the host definition
    vars.http_port = ${SLURPIT_PORT}         # Specify the port to check
    vars.http_uri = "/"                      # URI to check
    vars.http_expect = "200"                 # Expect HTTP 200 status code
}

# HTTP Service check for NetBox
object Service "NetBox" {
    host_name = "autocon-host"
    check_command = "http"
    vars.http_address = "${MY_EXTERNAL_IP}"  # IP address from the host definition
    vars.http_port = ${NETBOX_PORT}          # Specify the port to check
    vars.http_uri = "/"                      # URI to check
    vars.http_expect = "200"                 # Expect HTTP 200 status code
}

# HTTP Service check for NetBox
object Service "Netpicker" {
    host_name = "autocon-host"
    check_command = "http"
    vars.http_address = "${MY_EXTERNAL_IP}"  # IP address from the host definition
    vars.http_port = ${NETPICKER_PORT}       # Specify the port to check
    vars.http_uri = "/"                      # URI to check
    vars.http_expect = "200"                 # Expect HTTP 200 status code
}
EOL

echo "Icinga2 configuraiton updated."

popd