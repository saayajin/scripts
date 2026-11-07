#!/bin/zsh
# shellcheck shell=bash

# colors
LB='\e[1;34m' # light blue
R='\e[0m'     # reset color / no color


#####################
# COMMAND-NOT-FOUND #
#####################

# add command not found handler
echo 'source /usr/share/doc/pkgfile/command-not-found.zsh' >> ~/.zshrc

# update databse
sudo pkgfile -u

# enable automatic update
sudo systemctl enable --now pkgfile-update.timer


# finish
echo ""
echo "${LB}Done${R}"
echo ""
echo "Press any key to exit."
read -k 1 -r -s
