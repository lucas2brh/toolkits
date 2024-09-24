#!/bin/bash

# Check if binary path is provided
if [ -z "$1" ]; then
  echo "Usage: $0 <binary_path>"
  echo "Example: $0 /path/to/new/geth_binary"
  exit 1
fi

# Assign the input parameter to a variable
BINARY_PATH=$1

# Stop the services
echo "Stopping services..."
sudo systemctl stop cosmovisor.service && sudo systemctl stop node-geth

# Display current Geth version
echo "Current Geth version:"
geth version

# Check current Geth binary
echo "Current Geth binary location and permissions:"
ls -l /usr/local/bin/geth

# Copy the new binary to /usr/local/bin
echo "Copying new binary to /usr/local/bin/geth..."
sudo cp $BINARY_PATH /usr/local/bin/geth

# Display new Geth version
echo "New Geth version:"
geth version

# Check new Geth binary location and permissions
echo "New Geth binary location and permissions:"
ls -l /usr/local/bin/geth

# Start the services
echo "Starting services..."
sudo systemctl start node-geth && sudo systemctl start cosmovisor.service

echo "Upgrade process completed."
