#!/bin/bash
set -e


echo "Start install Puma Service"
cp packer/files/puma.service /etc/systemd/system/puma.service
systemctl enable puma.service
systemctl start puma.service
echo "End install Puma Service"
