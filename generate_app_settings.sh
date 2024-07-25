#!/bin/bash
#Currently attached for assessment and testing purposes

FLAVOR=$1

if [ "$FLAVOR" != "dev" ] && [ "$FLAVOR" != "qa" ] && [ "$FLAVOR" != "prod" ]; then
  echo "Error: This script is intended to be run for the 'dev', 'qa', or 'prod' flavors only."
  exit 1
fi

DIR="assets/cfg"
FILE="app_settings_${FLAVOR}.json"

if [ ! -d "$DIR" ]; then
  mkdir -p "$DIR"
  echo "Created directory: $DIR"
fi

if [ "$FLAVOR" = "dev" ]; then
  cat <<EOL > "$DIR/$FILE"
{
  "appName": "Mi'Wallet",
  "environment": "dev"
}
EOL
elif [ "$FLAVOR" = "qa" ]; then
  cat <<EOL > "$DIR/$FILE"
{
  "appName": "Mi'Wallet",
  "environment": "qa"
}
EOL
else
  cat <<EOL > "$DIR/$FILE"
{
  "appName": "Mi'Wallet",
  "environment": "prod"
}
EOL
fi

echo "Created file: $DIR/$FILE"

