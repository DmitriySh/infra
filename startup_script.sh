#!/bin/bash

echo user: `whoami`
echo path: `pwd`

sudo -u appuser git clone https://github.com/Artemmkin/reddit.git /home/appuser/reddit
cd /home/appuser/reddit

echo "Start install Ruby"
sudo -u appuser pg --keyserver hkp://keys.gnupg.net --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3
sudo -u appuser curl -sSL https://get.rvm.io | bash -s stable
sudo -u appuser source ~/.rvm/scripts/rvm
sudo -u appuser rvm requirements
sudo -u appuser rvm install 2.4.1
sudo -u appuser rvm use 2.4.1 --default
sudo -u appuser gem install bundler -V --no-ri --no-rdoc
echo ruby version: `sudo -u appuser ruby -v`
echo gem version: `sudo -u appuser gem -v bundler`
echo "End install Ruby"




echo "Start install MongoDB"
sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv EA312927
sudo bash -c 'echo "deb http://repo.mongodb.org/apt/ubuntu xenial/mongodb-org/3.2 multiverse" > /etc/apt/sources.list.d/mongodb-org-3.2.list'
sudo apt-get update
sudo systemctl start mongod
sudo systemctl enable mongod
sudo systemctl status mongod
echo "End install MongoDB"



echo "Start deploy"
sudo -u appuser source ~/.rvm/scripts/rvm
sudo -u appuser bundle install
sudo -u appuser puma -d
echo "End deploy"

