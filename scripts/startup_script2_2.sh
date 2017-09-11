#!/bin/bash

cd ~

echo user: `whoami`
echo path: `pwd`

echo "Start deploy"
git clone https://github.com/Artemmkin/reddit.git
cd reddit/
bundle install
puma -d
echo "End deploy"

