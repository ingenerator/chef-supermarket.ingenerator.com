#!/bin/bash

set -o nounset
set -o errexit
# Build absolute path to this script
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
INVENTORY_OUTPUT_DIR="$GITHUB_WORKSPACE/build/inventory"
WEB_OUTPUT_DIR="$GITHUB_WORKSPACE/build/web"

cd "$DIR/.."

echo "Compiling inventory file"
bundle exec bin/build-inventory.rb

echo "Building minimart inventory"
bundle exec bin/minimart mirror \
  --inventory_directory=$INVENTORY_OUTPUT_DIR

echo "Building minimart web endpoint"
bundle exec bin/minimart web \
  --inventory_directory=$INVENTORY_OUTPUT_DIR \
  --web_directory=$WEB_OUTPUT_DIR \
  --host=https://chef-supermarket.ingenerator.com

echo "Moving 'universe' file to force serving as JSON"
mv $WEB_OUTPUT_DIR/universe $WEB_OUTPUT_DIR/_universe
mkdir $WEB_OUTPUT_DIR/universe
mv $WEB_OUTPUT_DIR/_universe $WEB_OUTPUT_DIR/universe/index.json

echo "Build complete"
