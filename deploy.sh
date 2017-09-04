#!/bin/sh


# File deploy.sh
echo "Start deploy"

# Download project
mkdir git
cd git/
git clone https://github.com/Artemmkin/reddit.git

# Install dependencies
cd reddit && bundle install

# Run server
puma -d

echo "End deploy"

