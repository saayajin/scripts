#!/bin/zsh
# shellcheck shell=bash

# compress all mkv files. (x265)
# required: ffmpeg

mkdir -p .old-video
for f in $@; do
  ffmpeg -i "$f" -map 0 -c:v libx265 -preset ultrafast -crf 26 -pix_fmt yuv420p -c:a libopus -b:a 128k -c:s copy "${f%.*}.temp.mkv"
  touch -r "$f" "${f%.*}.temp.mkv"
  mv "$f" .old-video
  mv "${f%.*}.temp.mkv" "$f"
done

notify-send "Compression done"
