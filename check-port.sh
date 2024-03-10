#!/bin/bash

# Function to check if port is open
wait_for_port() {
 local port=$1
 local timeout=$2
 local start_time=$(date +%s)

 while :; do
    (echo > /dev/tcp/localhost/$port) >/dev/null 2>&1
    local result=$?
    if [[ $result -eq 0 ]]; then
      echo "Port $port is active."
      return 0
    else
      local current_time=$(date +%s)
      local elapsed=$((current_time - start_time))

      if [[ $elapsed -ge $timeout ]]; then
        echo "Timeout reached. Port $port did not become active within $timeout seconds."
        return 1
      fi
    fi
    sleep 5
 done
}

# Iterate over all arguments passed to the script
for port in "$@"; do
 echo "Waiting for port $port to be active..."
 if ! wait_for_port $port 120; then
    echo "Port $port did not become active within 120 seconds."
    exit 1
 fi
done

# Step 2: Continue with the rest of the script
echo "All specified ports are now active. Proceeding with the rest of the script..."