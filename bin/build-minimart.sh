#!/bin/bash

set -o nounset
set -o errexit
# Build absolute path to this script
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
DOCROOT="/var/www/chef-supermarket.ingenerator.com"

cd "$DIR/.."
echo "Installing / updating dependencies"
bundle install --deployment --binstubs

echo "Compiling inventory file"
bundle exec bin/build-inventory.rb

echo "Building minimart inventory"
bundle exec bin/minimart mirror

echo "Building minimart web endpoint"
bundle exec bin/minimart web --host=https://chef-supermarket.ingenerator.com

echo "Merging custom web files"
rsync -av $DIR/../web_extra/ $DIR/../web/

echo "Deploying web endpoint to $DOCROOT"
rsync -av --delete $DIR/../web/ $DOCROOT/

echo "Build complete"
