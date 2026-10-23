#!/bin/zsh
# shellcheck shell=bash

# resize and compress all mkv files. (x264)
# required: ffmpeg

mkdir -p .old-video
for f in $@; do
  res=$(ffmpeg -i "$f" 2>&1 | grep 'Stream #0:0.*Video' | grep -oP '\d{2,4}x\d{2,4}')
  width=$(echo $res | cut -d'x' -f1)
  height=$(echo $res | cut -d'x' -f2)
  if [ "$width" -gt "$height" ]; then
    ffmpeg -i "$f" -map 0 -c:v libx264 -preset veryfast -crf 22 -pix_fmt yuv420p -vf scale=-2:1080 -c:a libopus -b:a 128k -c:s copy "${f%.*}.temp.mkv"
  else
    ffmpeg -i "$f" -map 0 -c:v libx264 -preset veryfast -crf 22 -pix_fmt yuv420p -vf scale=1080:-2 -c:a libopus -b:a 128k -c:s copy "${f%.*}.temp.mkv"
  fi
  touch -r "$f" "${f%.*}.temp.mkv"
  mv "$f" .old-video
  mv "${f%.*}.temp.mkv" "$f"
done

notify-send "Compression done"
