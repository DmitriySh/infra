#!/bin/bash

sudo -u appuser git clone -b startup-script  https://github.com/DmitriySh/infra.git /home/appuser/infra
cd /home/appuser/infra

sudo -u appuser bash startup_script2.sh

