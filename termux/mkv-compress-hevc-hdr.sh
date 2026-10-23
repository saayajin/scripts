#!/bin/zsh
# shellcheck shell=bash

# compress all mkv files. (x265)
# required: ffmpeg

# colors
LB='\e[1;34m' # light blue
R='\e[0m'     # no color

# create empty lists
touch .list-mkv.txt .to-compress-mkv.txt .compressed-mkv.txt

# create mkv file list
ls *.[mM][kK][vV](N) > .list-mkv.txt

# create to-compress-mkv list
diff --suppress-common-lines .list-mkv.txt .compressed-mkv.txt | grep "^<\|^>" | sed "s/^. //g" > .to-compress-mkv.txt

# compress and add to compressed-mkv
tocom=("${(@f)$(cat .to-compress-mkv.txt)}")
mkdir -p .old-video
for file in "${tocom[@]}"; do
  ffmpeg -i "$file" -map 0 -c:v libx265 -preset ultrafast -crf 24 -pix_fmt yuv420p10le -c:a libopus -b:a 128k -c:s copy "${file%.*}.temp.mkv"
  touch -r "$file" "${file%.*}.temp.mkv"
  mv "$file" .old-video
  mv "${file%.*}.temp.mkv" "$file"
  echo "$file done"
  echo "${file}" >> .compressed-mkv.txt
done

# cleanup
rm -rf .list-mkv.txt .to-compress-mkv.txt

# finish
echo ""
echo "${LB}Done"
echo ""
echo "${R}Press any key to exit..."
read -k 1 -r -s
