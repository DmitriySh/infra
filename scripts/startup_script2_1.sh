#!/bin/bash

sudo -u appuser git clone -b feature/immutable-os-packer  https://github.com/DmitriySh/infra.git /home/appuser/infra
cd /home/appuser/infra

sudo -u appuser bash scripts/startup_script2_2.sh

