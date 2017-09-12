#!/bin/bash
set -e

# File install_ruby.sh
echo "Start install Ruby"

# Install RVM
gpg --keyserver hkp://keys.gnupg.net --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3
curl -sSL https://get.rvm.io | bash -s stable

# Enable RVM and dependencies for Ruby
source ~/.rvm/scripts/rvm
rvm requirements

# Install Ruby and make default version
rvm install 2.4.1
rvm use 2.4.1 --default

# For manage dependencies
gem install bundler -V --no-ri --no-rdoc

# Check Ruby и Bundler versions
ruby -v
gem -v bundler

echo "End install Ruby"

