#!/bin/bash

# Script to run Flutter app on different platforms
# Usage: ./run_app.sh -d <platform>
# Platform options: ios, android, web

# Default values
PLATFORM=""

# Parse command line arguments
while [[ $# -gt 0 ]]; do
  case $1 in
    -d|--device)
      PLATFORM="$2"
      shift 2
      ;;
    *)
      echo "Unknown option: $1"
      echo "Usage: $0 -d <platform>"
      echo "Platform options: ios, android, web"
      exit 1
      ;;
  esac
done

# Check if platform is provided
if [ -z "$PLATFORM" ]; then
  echo "Error: Platform is required"
  echo "Usage: $0 -d <platform>"
  echo "Platform options: ios, android, web"
  exit 1
fi

# Map platform to device ID
case $PLATFORM in
  ios)
    DEVICE_ID="426CD574-0E8E-477C-BA2E-55A0B22A3F9C"
    ;;
  android)
    DEVICE_ID="emulator-5554"
    ;;
  web)
    DEVICE_ID="chrome"
    ;;
  *)
    echo "Error: Invalid platform '$PLATFORM'"
    echo "Platform options: ios, android, web"
    exit 1
    ;;
esac

# Run Flutter app with the specified device
echo "Running Flutter app on $PLATFORM (device: $DEVICE_ID)..."
flutter run -d "$DEVICE_ID"

