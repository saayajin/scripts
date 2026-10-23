#!/bin/zsh
# shellcheck shell=bash

# crop thumbnails in all mp3 files.
# required: ffmpeg

# colors
LB='\e[1;34m' # light blue
R='\e[0m'     # no color

mkdir -p .old-music
for i in *.[mM][pP]3(N); do
  ffmpeg -i "$i" -vf "crop=min(iw\,ih):min(iw\,ih),scale=720:720" -map 0:a -map 0:v -c:a copy -c:v mjpeg -q:v 2 -id3v2_version 3 -metadata:s:v title="Album cover" -metadata:s:v comment="Cover (Front)" "${i%.*}.temp.mp3"
  touch -r "$i" "${i%.*}.temp.mp3"
  mv "$i" .old-music
  mv "${i%.*}.temp.mp3" "$i"
  echo "$i done"
done

# finish
echo ""
echo "${LB}Done"
echo ""
echo "${R}Press any key to exit..."
read -k 1 -r -s
