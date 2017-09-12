#!/bin/bash


# File deploy.sh
echo "Start deploy"

# Download project
git clone https://github.com/Artemmkin/reddit.git ~/reddit
cd ~/reddit

# Do not use new interpreter
source ~/.rvm/scripts/rvm

# Install dependencies
bundle install

# Run server
puma -d

echo "End deploy"

