#!/bin/sh


# File install_mongodb.sh
echo "Start install MongoDB"

# Add server
sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv EA312927
sudo bash -c 'echo "deb http://repo.mongodb.org/apt/ubuntuxenial/mongodb-org/3.2 multiverse" > /etc/apt/sources.list.d/mongodb-org-3.2.list'

# Update index and install MongoDB
sudo apt-get update
sudo apt-get install -y mongodb-org

# Start process MongoDB
sudo systemctl start mongod
sudo systemctl enable mongod

# Check process MongoDB
sudo systemctl status mongod

echo "End install MongoDB"

