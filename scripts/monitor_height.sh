#!/bin/bash

# Remote server details
REMOTE_USER="ec2-user"
REMOTE_IP="18.144.29.179"
SERVICE_NAME="node-story.service"

# Path to SSH key
SSH_KEY="~/.ssh/validator-yao.pem"

# Interval in seconds (default: 60 seconds)
INTERVAL=60

# Monitor remote logs and extract the latest height
last_height=""
while true; do
  # Get the latest height from logs
  latest_height=$(ssh -i "${SSH_KEY}" "${REMOTE_USER}@${REMOTE_IP}" \
    "journalctl -u ${SERVICE_NAME} -n 1 | grep 'height='" | \
    grep -o 'height=[0-9]*' | cut -d'=' -f2)

  if [[ -n "$latest_height" && "$latest_height" != "$last_height" ]]; then
    current_time=$(date '+%Y-%m-%d %H:%M:%S')
    echo "$current_time - Latest height: $latest_height"
    last_height="$latest_height"
  fi

  # Wait for the interval before the next check
  sleep $INTERVAL
done