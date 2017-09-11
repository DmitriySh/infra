#!/bin/bash

cd ~

echo user: `whoami`
echo path: `pwd`

echo "Start deploy"
source ~/.rvm/scripts/rvm
git clone https://github.com/Artemmkin/reddit.git ~/reddit
cd ~/reddit
bundle install
puma -d
echo "End deploy"

