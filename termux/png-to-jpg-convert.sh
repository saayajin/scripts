#!/bin/zsh
# shellcheck shell=bash

# convert all jpg to jpg.
# required: imagemagick

# colors
LB='\e[1;34m' # light blue
R='\e[0m'     # no color

# convert
mkdir -p .old-image
for i in *.[pP][nN][gG](N); do
  convert "$i" "${i%.*}.jpg"
  touch -r "$i" "${i%.*}.jpg"
  mv "$i" .old-image
  echo "${i%.*}.jpg done"
done

# finish
echo ""
echo "${LB}Done"
echo ""
echo "${R}Press any key to exit..."
read -k 1 -r -s
