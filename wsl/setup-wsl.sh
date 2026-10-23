#!/bin/bash
export PATH="$HOME/.local/bin:$PATH"

# variables
dl=$(wslpath -u "$(powershell.exe -NoProfile -command "(New-Object -ComObject Shell.Application).NameSpace('shell:Downloads').Self.Path" | tr -d '\r')")

#################
# INITIAL SETUP #
#################

# update & upgrade
sudo apt update
sudo apt upgrade -y

# install packages
sudo apt install -y aria2 curl ffmpeg git pipx python3 wget zsh

# install pip packages
pipx install gallery_dl mutagen yt-dlp

# create dirs
mkdir -p "$dl"/{Aria2,GalleryDL,Git,Websites,Wget}

#############
# OH-MY-ZSH #
#############

# install
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended

# copy template
cp "$HOME/.oh-my-zsh/templates/zshrc.zsh-template" "$HOME/.zshrc"

# change theme
sed -i 's/ZSH_THEME="robbyrussell"/ZSH_THEME="agnoster"/' "$HOME/.zshrc"

# add prompt context
echo -e 'prompt_context() {\n  if [[ "$USER" != "$DEFAULT_USER" || -n "$SSH_CLIENT" ]]; then\n    prompt_segment black default "%(!.%{%F{yellow}%}.)$USER"\n  fi\n}\n' >> "$HOME/.zshrc"

# change shell
chsh -s "$(command -v zsh)"
