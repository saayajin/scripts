#!/bin/zsh
# shellcheck shell=bash

# convert all jpg to png.
# required: imagemagick

# colors
LB='\e[1;34m' # light blue
R='\e[0m'     # no color

# convert
mkdir -p .old-image
for i in *.([jJ][pP][gG]|[jJ][pP][eE][gG])(N); do
  convert "$i" "${i%.*}.png"
  touch -r "$i" "${i%.*}.png"
  mv "$i" .old-image
  echo "${i%.*}.png done"
done

# finish
echo ""
echo "${LB}Done"
echo ""
echo "${R}Press any key to exit..."
read -k 1 -r -s
