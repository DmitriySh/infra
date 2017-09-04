#!/bin/sh


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


# --------------


echo "Start install MongoDB"

# Add server
sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv EA312927
sudo bash -c 'echo "deb http://repo.mongodb.org/apt/ubuntu xenial/mongodb-org/3.2 multiverse" > /etc/apt/sources.list.d/mongodb-org-3.2.list'

# Update index and install MongoDB
sudo apt-get update
sudo apt-get install -y mongodb-org

# Start process MongoDB
sudo systemctl start mongod
sudo systemctl enable mongod

# Check process MongoDB
sudo systemctl status mongod

echo "End install MongoDB"


# --------------


echo "Start deploy"

# Download project
cd ~
git clone https://github.com/Artemmkin/reddit.git

# Install dependencies
cd reddit && bundle install

# Run server
puma -d

echo "End deploy"

