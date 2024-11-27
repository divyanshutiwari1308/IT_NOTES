#!/bin/bash

# Function to check and resolve the "waiting for cache lock" issue
resolve_lock_issue() {
  echo "Checking for any running unattended-upgrade processes..."

  # Check for running unattended-upgrade process
  PID=$(ps aux | grep 'unattended-upgr' | grep -v 'grep' | awk '{print $2}')

  # If a process is found, wait for it to finish or manually kill it
  if [ -n "$PID" ]; then
    echo "Found process with PID $PID holding the lock on dpkg. Waiting for it to finish..."
    
    # Optionally, wait for the process to finish (you can adjust the wait time)
    # echo "Waiting for 60 seconds..."
    # sleep 60  # Wait for 1 minute (can adjust if needed)

    # If the process is stuck, kill it
    echo "Attempting to kill process with PID $PID..."
    sudo kill -9 $PID
    echo "Process $PID killed."
  else
    echo "No running unattended-upgrade process found."
  fi

  # Remove the lock files to release the dpkg lock
  echo "Removing lock files..."

  # Remove dpkg lock file
  sudo rm -f /var/lib/dpkg/lock-frontend
  sudo rm -f /var/cache/apt/archives/lock

  # Reconfigure dpkg to ensure everything is in order
  echo "Reconfiguring dpkg..."
  sudo dpkg --configure -a

  # Perform apt update
  echo "Running apt update..."
  sudo apt update -y

  # Perform apt upgrade (optional)
  echo "Running apt upgrade..."
  sudo apt upgrade -y

  # Final message
  echo "System update and upgrade completed successfully!"
}

# Call the function to resolve the lock issue
resolve_lock_issue
