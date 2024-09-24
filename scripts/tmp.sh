#!/bin/bash

# Function to handle errors globally
error_exit() {
    echo "$1" 1>&2
    exit 1
}

# Trap to catch any command errors and execute error_exit
trap 'error_exit "Error: Command failed."' ERR

# List of URLs and corresponding tarballs
files=(
    "https://story-geth-binaries.s3.us-west-1.amazonaws.com/story-public/story-linux-amd64-0.9.13-b4c7db1.tar.gz"
    "https://story-geth-binaries.s3.us-west-1.amazonaws.com/story-public/story-linux-amd64-0.10.0-9603826.tar.gz"
)

# Loop through URLs
for file in "${files[@]}"; do
    filename=$(basename $file)
    
    # Download
    echo "Downloading $filename..."
    wget $file --quiet
    
    # Extract
    echo "Extracting $filename..."
    tar xzvf $filename || error_exit "Error: Failed to extract $filename"
done

# Batch delete tar.gz files after extraction
echo "Cleaning up tar.gz files..."
rm -f *.tar.gz

# Change permissions for cosmovisor
echo "Setting permissions for cosmovisor..."
sudo chmod 777 ./cosmovisor || error_exit "Error: Failed to set permissions for cosmovisor"

# Check cosmovisor version
echo "Checking cosmovisor version..."
./cosmovisor version || error_exit "Error: Failed to run cosmovisor version command"

echo "All steps completed successfully."