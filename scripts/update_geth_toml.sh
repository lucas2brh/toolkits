#!/bin/bash

if [ -z "$1" ]; then
  echo "Usage: $0 <OverrideStoryNostoi_value>"
  exit 1
fi

nostoi_value=$1

config_file=$(find / -name "geth.toml" 2>/dev/null | grep "/geth/config/geth.toml")

if [ -z "$config_file" ]; then
  echo "Error: geth.toml file not found."
  exit 1
fi

if grep -q "OverrideStoryNostoi" "$config_file"; then
  sed -i "s/OverrideStoryNostoi = .*/OverrideStoryNostoi = $nostoi_value/" "$config_file"
  echo "OverrideStoryNostoi value updated to $nostoi_value in $config_file."
else
  sed -i "/\[Eth\]/a OverrideStoryNostoi = $nostoi_value" "$config_file"
  echo "OverrideStoryNostoi = $nostoi_value added to [Eth] section in $config_file."
fi