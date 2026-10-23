#!/bin/zsh
# shellcheck shell=bash

# compress all png files.
# required: oxipng

# colors
LB='\e[1;34m' # light blue
R='\e[0m'     # no color

# create empty lists
touch .list-png.txt .to-compress-png.txt .compressed-png.txt

# create png file list
ls *.[pP][nN][gG](N) > .list-png.txt

# create to-compress-png list
diff --suppress-common-lines .list-png.txt .compressed-png.txt | grep "^<\|^>" | sed "s/^. //g" > .to-compress-png.txt

# compress and add to compressed-png
tocom=("${(@f)$(cat .to-compress-png.txt)}")
mkdir -p .old-image
for file in "${tocom[@]}"; do
  oxipng -q -o 2 --out="${file%.*}.temp.png" "$file"
  touch -r "$file" "${file%.*}.temp.png"
  mv "$file" .old-image
  mv "${file%.*}.temp.png" "$file"
  echo "$file done"
  echo "${file}" >> .compressed-png.txt
done

# cleanup
rm -rf .list-png.txt .to-compress-png.txt

# finish
echo ""
echo "${LB}Done"
echo ""
echo "${R}Press any key to exit..."
read -k 1 -r -s
