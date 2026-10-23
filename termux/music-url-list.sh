#!/bin/zsh
# shellcheck shell=bash

# generate url list from downloaded music (yt-dlp)
# required: python, mutagen

# colors
LB='\e[1;34m' # light blue
R='\e[0m'     # no color

for i in *.[mM][pP]3(N); do
  echo $(mid3v2 -l "$i" | grep TXXX=purl | cut -d'=' -f3-) >> url-list.txt
done

# finish
echo ""
echo "${LB}Done"
echo ""
echo "${R}Press any key to exit..."
read -k 1 -r -s
