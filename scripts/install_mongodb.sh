#!/bin/bash
set -e

# File install_mongodb.sh
echo "Start install MongoDB"

# Add server
apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv EA312927
bash -c 'echo "deb http://repo.mongodb.org/apt/ubuntu xenial/mongodb-org/3.2 multiverse" > /etc/apt/sources.list.d/mongodb-org-3.2.list'

# Update index and install MongoDB
apt-get update
apt-get install -y mongodb-org

# Start process MongoDB
systemctl start mongod
systemctl enable mongod

# Check process MongoDB
systemctl status mongod

echo "End install MongoDB"

