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
  # Read the last 10 logs and extract the latest height
  latest_height=$(ssh -i "${SSH_KEY}" "${REMOTE_USER}@${REMOTE_IP}" \
    "journalctl -u ${SERVICE_NAME} -n 10 | grep 'height='" | \
    grep -o 'height=[0-9]*' | tail -n 1 | cut -d'=' -f2)

  current_time=$(date '+%Y-%m-%d %H:%M:%S')

  # Print the height, even if it hasn't changed
  if [[ -n "$latest_height" && "$latest_height" != "$last_height" ]]; then
    echo -e "$current_time - Latest height: \033[0;31m$latest_height\033[0m"
    last_height="$latest_height"
  elif [[ -n "$latest_height" ]]; then
    echo "$current_time - Height unchanged: $latest_height"
  else
    echo "$current_time - No height found in recent logs"
  fi

  # Wait for the interval before the next check
  sleep $INTERVAL
done