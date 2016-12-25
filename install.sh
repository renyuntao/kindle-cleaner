#!/usr/bin/env bash

BO="\x1B[94m\x1B[1m"
RO="\x1B[91m\x1B[1m"
NOR="\x1B[0m"

echo -e "${RO}Install ...${NOR}"
sudo cp -v kindle-cleaner /usr/bin/
sudo chown `whoami` /usr/bin/kindle-cleaner
sudo chmod a+x /usr/bin/kindle-cleaner
sudo cp -v kindle-cleaner.1.gz /usr/share/man/man1/
sudo mandb 
echo -e "${BO}INSTALL SUCCESS!${NOR}"
