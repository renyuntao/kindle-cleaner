#!/usr/bin/env bash

BO="\x1B[94m\x1B[1m"
RO="\x1B[91m\x1B[1m"
NOR="\x1B[0m"

echo -e "${RO}Uninstall ...${NOR}"
sudo rm -f /usr/bin/kindle-cleaner
sudo rm -f /usr/share/man/man1/kindle-cleaner.1.gz
sudo mandb
echo -e "${BO}UNINSTALL SUCCESS!${NOR}"

