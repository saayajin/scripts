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
sudo apt install -y aria2 curl eza ffmpeg git megatools pipx python3 wget zsh

# install pip packages
pipx install gallery_dl mutagen yt-dlp

# create dirs
mkdir -p "$dl"/{Aria2,GalleryDL,Git,Mega,Websites,Wget}

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
echo -e '\nprompt_context() {\n  if [[ "$USER" != "$DEFAULT_USER" || -n "$SSH_CLIENT" ]]; then\n    prompt_segment black default "%(!.%{%F{yellow}%}.)$USER"\n  fi\n}\n' >> "$HOME/.zshrc"

# change shell
chsh -s "$(command -v zsh)"

##############
# CHPWD HOOK #
##############

# set chpwd hook
cat >> "$HOME/.zshrc"<< EOF
chpwd() {
  eza -aF --group-directories-first
}

EOF

##############
# ENABLE ZMV #
##############

# insert autoload
echo -e 'autoload zmv\n' >> "$HOME/.zshrc"

##################
# ZSH HELIX MODE #
##################

# install zsh-helix-mode plugin
git clone https://github.com/Multirious/zsh-helix-mode --depth 1 "$HOME/.oh-my-zsh/custom/plugins/zsh-helix-mode"

# enable zsh-helix-mode plugin
sed -i 's/^plugins=(\(.*\))/plugins=(\1 zsh-helix-mode)/' "$HOME/.zshrc"

##########
# FINISH #
##########

# echo
echo "Setup done."
read -n 1 -r -s
