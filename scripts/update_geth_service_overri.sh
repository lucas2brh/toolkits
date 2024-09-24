#!/bin/bash

if [ -z "$1" ]; then
  echo "Usage: $0 <BLOCK_NUMBER>"
  exit 1
fi

BLOCK_NUMBER=$1
SERVICE_FILE="/etc/systemd/system/node-geth.service"


if [ ! -f "$SERVICE_FILE" ]; then
  echo "Service file not found: $SERVICE_FILE"
  exit 1
fi


sudo sed -i "s|^ExecStart=.*|ExecStart=geth --config=/home/ec2-user/geth/config/geth.toml --metrics --metrics.addr 0.0.0.0 --override.nostoi ${BLOCK_NUMBER} |" $SERVICE_FILE


sudo systemctl daemon-reload
# sudo systemctl restart node-geth.service
cat /etc/systemd/system/node-geth.service
echo "Service updated and restarted with BLOCK_NUMBER=${BLOCK_NUMBER}"
