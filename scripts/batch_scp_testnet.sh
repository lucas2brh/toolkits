#!/bin/bash

# Check if the required arguments are provided
if [ $# -lt 2 ]; then
  echo "Usage: $0 <file-path> <destination-path>"
  echo "Example: $0 ~/workspace/geth_upgrade/geth_after /home/ec2-user/geth_after"
  exit 1
fi

# Input file path and destination path from arguments
FILE_PATH=$1
DEST_PATH=$2

# List of public-testnet hosts with their respective SSH keys and hostnames
HOSTS=(
  "ec2-3-209-222-188.compute-1.amazonaws.com:~/.ssh/public-testnet-us-east-1.pem"
  "ec2-54-183-204-164.us-west-1.compute.amazonaws.com:~/.ssh/public-testnet-us-west-1.pem"
  "ec2-44-223-234-211.compute-1.amazonaws.com:~/.ssh/public-testnet-us-east-1.pem"
  "ec2-3-222-216-118.compute-1.amazonaws.com:~/.ssh/public-testnet-us-east-1.pem"
  "ec2-52-9-183-131.us-west-1.compute.amazonaws.com:~/.ssh/public-testnet-us-west-1.pem"
  "ec2-184-169-154-204.us-west-1.compute.amazonaws.com:~/.ssh/public-testnet-us-west-1.pem"
  "ec2-63-35-134-129.eu-west-1.compute.amazonaws.com:~/.ssh/public-testnet-eu-west-1.pem"
  "ec2-3-248-113-42.eu-west-1.compute.amazonaws.com:~/.ssh/public-testnet-eu-west-1.pem"
  "ec2-3-1-137-11.ap-southeast-1.compute.amazonaws.com:~/.ssh/public-testnet-ap-southeast-1.pem"
  "ec2-52-74-117-64.ap-southeast-1.compute.amazonaws.com:~/.ssh/public-testnet-ap-southeast-1.pem"
  "ec2-54-209-160-71.compute-1.amazonaws.com:~/.ssh/public-testnet-us-east-1.pem"
  "ec2-3-225-157-207.compute-1.amazonaws.com:~/.ssh/public-testnet-us-east-1.pem"
  "ec2-3-209-222-59.compute-1.amazonaws.com:~/.ssh/public-testnet-us-east-1.pem"
  "ec2-34-234-176-168.compute-1.amazonaws.com:~/.ssh/public-testnet-us-east-1.pem"
  # "ec2-3-230-220-17.compute-1.amazonaws.com:~/.ssh/public-testnet-us-east-1.pem" #explorer
)

# Loop over hosts and perform SCP
for HOST_INFO in "${HOSTS[@]}"; do
  IFS=":" read -r HOST KEY_PATH <<< "$HOST_INFO"
  echo "Transferring to $HOST..."
  scp -i $KEY_PATH $FILE_PATH ec2-user@$HOST:$DEST_PATH
  if [ $? -eq 0 ]; then
    echo "Transfer to $HOST completed."
  else
    echo "Transfer to $HOST failed."
  fi
done