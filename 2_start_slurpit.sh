#!/bin/bash
set -euo pipefail

# Check if COMMIT_HASH is set by the user, otherwise use default
COMMIT_HASH="${COMMIT_HASH:-3e2d20458e46cc026d39fde599f01f2a615a2e25}"

# Check if PORTAL_BASE_URL is set by the user, otherwise use default
PORTAL_BASE_URL="${PORTAL_BASE_URL:-http://147.28.133.39:8000/}"

# Echo the values being used
echo "--- Using COMMIT_HASH: $COMMIT_HASH ---"
echo "--- Using PORTAL_BASE_URL: $PORTAL_BASE_URL ---"

# Install unzip
echo
echo "--- Installing unzip ---"
echo
apt install -y unzip

# Pulling Slurpit
echo
echo "--- Pulling Slurpit at version: $COMMIT_HASH ---"
echo

# Create a directory for Slurpit if it doesn't exist
mkdir -p slurpit

# Create a temporary directory for the extraction
TEMP_DIR=$(mktemp -d)

# Download and unzip into the temporary directory
wget "https://gitlab.com/slurpit.io/images/-/archive/$COMMIT_HASH/images-$COMMIT_HASH.zip" -O slurpit.zip
unzip slurpit.zip -d "$TEMP_DIR"

# Move the contents of the extracted folder to the 'slurpit' directory
mv "$TEMP_DIR"/images-"$COMMIT_HASH"/* slurpit/

# Clean up: remove the zip file and the temporary directory
rm slurpit.zip
rm -rf "$TEMP_DIR"

# Change to the slurpit directory
pushd slurpit

# Update docker-compose.override.yml BEFORE running up.sh
echo
echo "--- Updating docker-compose.override.yml ---"
echo

# Rename the example file to docker-compose.override.yml
mv docker-compose.override-EXAMPLE.yml docker-compose.override.yml

# Update the PORTAL_BASE_URL line using sed, replacing with the variable
sed -i "s|PORTAL_BASE_URL: http://localhost|PORTAL_BASE_URL: $PORTAL_BASE_URL|" docker-compose.override.yml

# Update the outside port
sed -i 's/80:80/8000:80/' docker-compose.override.yml

# Remove SSL/TLS
sed -i '/443:443/d' docker-compose.override.yml

echo "--- docker-compose.override.yml has been updated ---"

# Ensure up.sh is executable
chmod +x up.sh

# Run up.sh inside the slurpit directory (docker compose up is executed here)
echo
echo "--- Running up.sh ---"
echo
./up.sh

# Return to the original directory
popd