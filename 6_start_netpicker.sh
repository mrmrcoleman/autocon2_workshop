#!/bin/bash
set -euo pipefail

echo
echo "--- Starting Netpicker ---"
echo

pushd netpicker
docker compose up -d
popd