#!/bin/bash


# File deploy.sh
echo "Start deploy"

gpg --keyserver hkp://keys.gnupg.net --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3
curl -sSL https://get.rvm.io | bash -s stable

# Download project
git clone https://github.com/Artemmkin/reddit.git ~/reddit

# Install dependencies
~/reddit/bundle install

# Run server
~/reddit/puma -d

echo "End deploy"

