#!/bin/bash


# File deploy.sh
echo "Start deploy"

# Download project
git clone https://github.com/Artemmkin/reddit.git ~/reddit

# Install dependencies
~/reddit/bundle install

# Run server
~/reddit/puma -d

echo "End deploy"

