#!/bin/zsh
# shellcheck shell=bash

# compress all mp4 files. (x265)
# required: ffmpeg

mkdir -p .old-video
for f in $@; do
  ffmpeg -i "$f" -map 0 -movflags +faststart -c:v libx265 -preset ultrafast -crf 26 -pix_fmt yuv420p -c:a aac -b:a 192k "${f%.*}.temp.mp4"
  touch -r "$f" "${f%.*}.temp.mp4"
  mv "$f" .old-video
  mv "${f%.*}.temp.mp4" "$f"
done

notify-send "Compression done"
