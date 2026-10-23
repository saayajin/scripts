#!/bin/zsh
# shellcheck shell=bash

# compress all jpg files.
# required: imagemagick

# colors
LB='\e[1;34m' # light blue
R='\e[0m'     # no color

# create empty lists
touch .list-jpg.txt .to-compress-jpg.txt .compressed-jpg.txt

# create jpg file list
ls *.([jJ][pP][gG]|[jJ][pP][eE][gG])(N) > .list-jpg.txt

# create to-compress-jpg list
diff --suppress-common-lines .list-jpg.txt .compressed-jpg.txt | grep "^<\|^>" | sed "s/^. //g" > .to-compress-jpg.txt

# compress and add to compressed-jpg
tocom=("${(@f)$(cat .to-compress-jpg.txt)}")
mkdir -p .old-image
for file in "${tocom[@]}"; do
  magick -sampling-factor 4:2:0 -interlace Plane -quality 85 "$file" "${file%.*}.temp.jpg"
  touch -r "$file" "${file%.*}.temp.jpg"
  mv "$file" .old-image
  mv "${file%.*}.temp.jpg" "$file"
  echo "$file done"
  echo "$file" >> .compressed-jpg.txt
done

# cleanup
rm -f .list-jpg.txt .to-compress-jpg.txt

# finish
echo ""
echo "${LB}Done"
echo ""
echo "${R}Press any key to exit..."
read -k 1 -r -s
