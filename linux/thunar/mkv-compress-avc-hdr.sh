#!/bin/zsh
# shellcheck shell=bash

# compress all mkv files. (x264)
# required: ffmpeg

mkdir -p .old-video
for f in $@; do
  ffmpeg -i "$f" -map 0 -c:v libx264 -preset veryfast -crf 20 -pix_fmt yuv420p10le -c:a libopus -b:a 128k -c:s copy "${f%.*}.temp.mkv"
  touch -r "$f" "${f%.*}.temp.mkv"
  mv "$f" .old-video
  mv "${f%.*}.temp.mkv" "$f"
done

notify-send "Compression done"
