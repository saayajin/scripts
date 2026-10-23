#!/bin/zsh
# shellcheck shell=bash
export PATH="$HOME/.local/bin:$PATH"

# variables
target=$(powershell.exe -command "Get-Clipboard" | tr -d '\r')
dl=$(wslpath -u "$(powershell.exe -NoProfile -command "(New-Object -ComObject Shell.Application).NameSpace('shell:Downloads').Self.Path" | tr -d '\r')")

# colors
LR='\e[1;31m' # light red
LG='\e[1;32m' # light green
LY='\e[1;33m' # light yellow
LB='\e[1;34m' # light blue
R='\e[0m'     # no color

# check target
if [ -z "$target" ]; then
  echo "${LR}Clipboard empty."
  echo ""
  echo "${R}Press any key to exit..."
  read -k 1 -r -s
  exit 1
fi

# options
echo "Analysing URL..."
echo "[$target]"
echo ""
echo "${LG}What should i do?"
echo ""
echo "${LY}v${R}) Download video"
echo "${LY}f${R}) Download video (Select format)"
echo "${LY}m${R}) Download music"
echo "${LY}k${R}) Download with gallery-dl"
echo "${LY}i${R}) Download with gallery-dl (images only)"
echo "${LY}w${R}) Download with wget"
echo "${LY}a${R}) Download with aria2"
echo "${LY}g${R}) Clone git"
echo "${LY}s${R}) Clone website"
echo "${LY}x${R}) ${LR}Exit${R}"

read CHOICE
case $CHOICE in

################
# YT-DLP VIDEO #
################

v)
  yt-dlp -f "bv*[ext=mp4]+ba[ext=m4a]/b[ext=mp4] / bv*+ba/b" --no-mtime -o "$dl/Video/%(title)s.%(ext)s" "$target"
  if [ $? -eq 0 ]; then
    echo "${LB}Done.${R}"
    sleep 3s
  else
    echo "${LR}Error."
    echo ""
    echo "${R}Press any key to exit..."
    read -k 1 -r -s
  fi
  ;;

#################
# YT-DLP FORMAT #
#################

f)
  yt-dlp -F "$target"
  echo "${LG}Select the format:${R}"
  read FORMAT
  yt-dlp -f "$FORMAT" --no-mtime -o "$dl/Video/%(title)s.%(ext)s" "$target"
  if [ $? -eq 0 ]; then
    echo "${LB}Done.${R}"
    sleep 3s
  else
    echo "${LR}Error."
    echo ""
    echo "${R}Press any key to exit..."
    read -k 1 -r -s
  fi
  ;;

################
# YT-DLP MUSIC #
################

m)
  yt-dlp -x --audio-format mp3 --audio-quality 0 --embed-thumbnail --convert-thumbnail jpg --ppa "EmbedThumbnail+ffmpeg_o:-c:v mjpeg -q:v 2 -vf \"crop=min(iw\\,ih):min(iw\\,ih),scale=720:720\"" --exec ffprobe --embed-metadata --no-mtime -o "$dl/Music/%(artist,uploader)s - %(title)s.%(ext)s" "$target"
  if [ $? -eq 0 ]; then
    echo "${LB}Done.${R}"
    sleep 3s
  else
    echo "${LR}Error."
    echo ""
    echo "${R}Press any key to exit..."
    read -k 1 -r -s
  fi
  ;;

##############
# GALLERY-DL #
##############

k)
  gallery-dl --no-mtime -f '{filename}.{extension}' -d "$dl/GalleryDL" "$target"
  if [ $? -eq 0 ]; then
    echo "${LB}Done.${R}"
    sleep 3s
  else
    echo "${LR}Error."
    echo ""
    echo "${R}Press any key to exit..."
    read -k 1 -r -s
  fi
  ;;

#####################
# GALLERY-DL IMAGES #
#####################

i)
  gallery-dl --no-mtime -f '{filename}.{extension}' --filter "extension in ('apng','bmp','dng','gif','heic','jpeg','jpg','png','svg','tiff','webp')" -d "$dl/GalleryDL" "$target"
  if [ $? -eq 0 ]; then
    echo "${LB}Done.${R}"
    sleep 3s
  else
    echo "${LR}Error."
    echo ""
    echo "${R}Press any key to exit..."
    read -k 1 -r -s
  fi
  ;;

########
# WGET #
########

w)
  wget -P "$dl/Wget" "$target"
  if [ $? -eq 0 ]; then
    echo "${LB}Done.${R}"
    sleep 3s
  else
    echo "${LR}Error."
    echo ""
    echo "${R}Press any key to exit..."
    read -k 1 -r -s
  fi
  ;;

#########
# ARIA2 #
#########

a)
  aria2c -d "$dl/Aria2" "$target"
  if [ $? -eq 0 ]; then
    echo "${LB}Done.${R}"
    sleep 3s
  else
    echo "${LR}Error."
    echo ""
    echo "${R}Press any key to exit..."
    read -k 1 -r -s
  fi
  ;;

#############
# CLONE GIT #
#############

g)
  echo "${LG}Enter repository name:${R}"
  read REPO
  git clone "$target" "$dl/Git/$REPO"
  if [ $? -eq 0 ]; then
    echo "${LB}Done.${R}"
    sleep 3s
  else
    echo "${LR}Error."
    echo ""
    echo "${R}Press any key to exit..."
    read -k 1 -r -s
  fi
  ;;

#################
# CLONE WEBSITE #
#################

s)
  wget --mirror --page-requisites --html-extension --convert-links -P "$dl/Websites" "$target"
  if [ $? -eq 0 ]; then
    echo "${LB}Done.${R}"
    sleep 3s
  else
    echo "${LR}Error."
    echo ""
    echo "${R}Press any key to exit..."
    read -k 1 -r -s
  fi
  ;;

########
# EXIT #
########

x)
  echo "${LB}Bye ;)${R}"
  sleep 2s
  ;;

esac
