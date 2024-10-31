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

# List of odyssey-devnet hosts with their respective SSH keys and hostnames
HOSTS=(
  "ec2-100-29-109-239.compute-1.amazonaws.com:~/.ssh/odyssey-devnet-us-east-1.pem"
  "ec2-52-53-108-57.us-west-1.compute.amazonaws.com:~/.ssh/odyssey-devnet-us-west-1.pem"

  "ec2-52-202-215-77.compute-1.amazonaws.com:~/.ssh/odyssey-devnet-us-east-1.pem"
  "ec2-98-83-76-124.compute-1.amazonaws.com:~/.ssh/odyssey-devnet-us-east-1.pem"
  "ec2-54-241-22-141.us-west-1.compute.amazonaws.com:~/.ssh/odyssey-devnet-us-west-1.pem"
  "ec2-52-52-75-71.us-west-1.compute.amazonaws.com:~/.ssh/odyssey-devnet-us-west-1.pem"
  "ec2-34-247-112-220.eu-west-1.compute.amazonaws.com:~/.ssh/odyssey-devnet-eu-west-1.pem"
  "ec2-54-194-49-103.eu-west-1.compute.amazonaws.com:~/.ssh/odyssey-devnet-eu-west-1.pem"
  "ec2-52-221-135-242.ap-southeast-1.compute.amazonaws.com:~/.ssh/odyssey-devnet-ap-southeast-1.pem"
  "ec2-13-229-16-107.ap-southeast-1.compute.amazonaws.com:~/.ssh/odyssey-devnet-ap-southeast-1.pem"

  "ec2-44-208-90-48.compute-1.amazonaws.com:~/.ssh/odyssey-devnet-us-east-1.pem"
  "ec2-54-165-95-27.compute-1.amazonaws.com:~/.ssh/odyssey-devnet-us-east-1.pem"
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