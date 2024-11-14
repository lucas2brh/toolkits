#!/bin/bash

# wget https://github.com/cosmos/cosmos-sdk/releases/download/cosmovisor%2Fv1.6.0/cosmovisor-v1.6.0-linux-amd64.tar.gz && tar -zxvf cosmovisor-v1.6.0-linux-amd64.tar.gz

# sudo chmod +x ssetup_cosmovisor_velia.sh  && ./setup_cosmovisor_velia.sh /usr/local/bin/story


export DAEMON_NAME=story
export DAEMON_HOME=$HOME/.story/story

# Create necessary directories
mkdir -p $DAEMON_HOME 
mkdir -p $DAEMON_HOME/cosmovisor
mkdir -p $DAEMON_HOME/data
mkdir -p $DAEMON_HOME/backup

# Assuming you have the cosmovisor binary ready, copy it to /usr/local/bin
if [ -f "./cosmovisor" ]; then
    echo "Copying cosmovisor binary to /usr/local/bin..."
    sudo cp ./cosmovisor /usr/local/bin/
    if [ $? -ne 0 ]; then
        echo "Error: Failed to copy cosmovisor to /usr/local/bin."
        exit 1
    fi
else
    echo "Error: cosmovisor binary not found in the current directory."
    exit 1
fi

# Ensure cosmovisor is executable
sudo chmod +x /usr/local/bin/cosmovisor
echo "cosmovisor is installed and executable at /usr/local/bin."



# Initialize cosmovisor with the provided binary path
BINARY_PATH=$1
if [ -z "$BINARY_PATH" ]; then
    echo "Error: No binary path provided for cosmovisor init."
    echo "Usage: $0 <binary_path>"
    exit 1
fi

cosmovisor init "$BINARY_PATH"

# Output cosmovisor version
cosmovisor version
if [ $? -ne 0 ]; then
    echo "Error: Failed to get cosmovisor version."
    exit 1
fi

# Create or overwrite cosmovisor service file
sudo bash -c 'cat > /etc/systemd/system/cosmovisor.service <<EOF
[Unit]
Description=cosmovisor
After=network.target

[Service]
Type=simple
User=velia-user
Group=velia-user
ExecStart=/usr/local/bin/cosmovisor run run --home=/home/velia-user/.story/story
Restart=on-failure
RestartSec=5s
LimitNOFILE=65536
Environment="DAEMON_NAME=story"
Environment="DAEMON_HOME=/home/velia-user/.story/story"
Environment="DAEMON_ALLOW_DOWNLOAD_BINARIES=false"
Environment="DAEMON_RESTART_AFTER_UPGRADE=true"
Environment="DAEMON_DATA_BACKUP_DIR=/home/velia-user/.story/story/backup"
WorkingDirectory=/home/velia-user

[Install]
WantedBy=multi-user.target
EOF'

echo "cosmovisor service created or overwritten."

# Reload systemd to recognize the new or updated service
sudo systemctl daemon-reload

# Stop any existing services
sudo systemctl stop node-story
sudo systemctl stop cosmovisor

# Start the cosmovisor service
sudo systemctl start cosmovisor

# Check the service logs
journalctl -f -u cosmovisor.service