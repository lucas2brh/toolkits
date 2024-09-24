#!/bin/bash

# Check if the required arguments are provided
if [ $# -lt 3 ]; then
  echo "Usage: $0 <file-path> <destination-path> <network-type>"
  echo "Example: $0 ~/workspace/geth_upgrade/geth_after /home/ec2-user/geth_after mininet"
  echo "Example: $0 ~/workspace/geth_upgrade/geth_after /home/ec2-user/geth_after devnet"
  exit 1
fi

# Input file path, destination path, and network type from arguments
FILE_PATH=$1
DEST_PATH=$2
NETWORK_TYPE=$3
# SSH key path
KEY_PATH="~/.ssh/devnet-aws-stg.pem"

# List of mininet servers
MININET_SERVERS=(
  "mini-boot"
  "mini-validator1-54.215.121.164"
  "mini-validator2-13.57.248.181"
  "mini-validator3-13.57.208.207"
  "mini-validator4-18-144-99-223"
)

# List of devnet servers
DEVNET_SERVERS=(
  "devnet-validator1-54.193.206.2"
  "devnet-validator2-204.236.149.190"
  "devnet-validator3-13.57.205.57"
  "devnet-validator4-52.53.213.187"
  "devnet-validator5-54.153.111.104"
  "devnet-validator6-18.144.166.110"
  "devnet-validator7-18.144.89.70"
  "devnet-validator8-54.151.6.221"
  "devnet-validator9-18.144.23.168"
  "devnet-validator10-54.183.120.252"
  "devnet-validator11-54.215.99.101"
  "devnet-validator12-13.52.214.176"
  "devnet-validator13-54.215.246.207"
  "devnet-validator14-13.57.214.146"
  "devnet-validator15-13.52.239.195"
  "devnet-rpc1-50.18.137.192"
  "devnet-bootnode1-52.9.220.233"
  "devnet-bootnode2-54.241.155.73"
)

# Select the appropriate server list based on network type
if [ "$NETWORK_TYPE" == "mininet" ]; then
  SERVERS=("${MININET_SERVERS[@]}")
elif [ "$NETWORK_TYPE" == "devnet" ]; then
  SERVERS=("${DEVNET_SERVERS[@]}")
else
  echo "Invalid network type. Please specify 'mininet' or 'devnet'."
  exit 1
fi

# Loop through the selected list of servers and transfer files
for SERVER in "${SERVERS[@]}"; do
  echo "Transferring file to $SERVER..."
  scp -i $KEY_PATH $FILE_PATH $SERVER:$DEST_PATH

  if [ $? -eq 0 ]; then
    echo "File successfully transferred to $SERVER."
  else
    echo "Error transferring file to $SERVER."
  fi
done