#!/bin/bash


echo "Start deploy"
git clone https://github.com/Artemmkin/reddit.git /home/appuser/reddit
cd /home/appuser/reddit
source /home/appuser/.rvm/scripts/rvm
bundle install
echo "End deploy"

