#!/bin/bash
set -euo pipefail

# Starting network
echo
echo "--- Starting network ---"
echo

pushd network
clab deploy --topo autocon2.clab.yml
popd