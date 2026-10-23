#!/bin/zsh
# shellcheck shell=bash

# delete some tags in all mp3 files.
# required: python, mutagen

# colors
LB='\e[1;34m' # light blue
R='\e[0m'     # no color

for i in *.[mM][pP]3(N); do
  mid3v2 --delete-frame="COMM:ID3v1 Comment:eng,TXXX:comment,TXXX:description,TXXX:synopsis" "$i"
  echo "$i done"
done

# finish
echo ""
echo "${LB}Done"
echo ""
echo "${R}Press any key to exit..."
read -k 1 -r -s
