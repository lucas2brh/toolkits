#!/bin/bash

# Ensure that all required parameters are provided
if [ -z "$1" ] || [ -z "$2" ] || [ -z "$3" ]; then
    echo "Error: Missing required parameters."
    echo "Usage: $0 <version> <binary_path> <upgrade_height>"
    exit 1
fi

# Assigning the input parameters to variables
VERSION=$1
BINARY_PATH=$2
UPGRADE_HEIGHT=$3

# Environment setup
export DAEMON_NAME=story
export DAEMON_HOME=$HOME/story

# Display cosmovisor version
cosmovisor version

# Add the upgrade to cosmovisor
cosmovisor add-upgrade "$VERSION" "$BINARY_PATH" --force --upgrade-height "$UPGRADE_HEIGHT"

# Notify that the upgrade plan is scheduled
echo "Upgrade to version $VERSION scheduled at block height $UPGRADE_HEIGHT."

# Display cosmovisor version
cosmovisor version