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
sudo apt install -y aria2 curl eza ffmpeg fzf git megatools pipx python3 wget zsh

# install pip packages
pipx install gallery_dl mutagen yt-dlp

# create dirs
mkdir -p "$dl"/{Aria2,GalleryDL,Git,Mega,Websites,Wget}

#############
# OH-MY-ZSH #
#############

# remove old repo dir
rm -rf "$HOME/.oh-my-zsh"

# clone repo
git clone --single-branch --branch master https://github.com/ohmyzsh/ohmyzsh.git "$HOME/.oh-my-zsh"

# copy template
cp "$HOME/.oh-my-zsh/templates/zshrc.zsh-template" "$HOME/.zshrc"

# change theme
sed -i 's/ZSH_THEME="robbyrussell"/ZSH_THEME="agnoster"/' "$HOME/.zshrc"

# add prompt context
echo -e '\nprompt_context() {\n  if [[ "$USER" != "$DEFAULT_USER" || -n "$SSH_CLIENT" ]]; then\n    prompt_segment black default "%(!.%{%F{yellow}%}.)$USER"\n  fi\n}\n' >> "$HOME/.zshrc"

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

###############
# ZSH PLUGINS #
###############

# install zsh-helix-mode
git clone https://github.com/Multirious/zsh-helix-mode --depth 1 "$HOME/.oh-my-zsh/custom/plugins/zsh-helix-mode"

# install zsh-autoggestions
git clone https://github.com/zsh-users/zsh-autosuggestions "$HOME/.oh-my-zsh/custom/plugins/zsh-autosuggestions"

# enable plugins
sed -i 's/^plugins=(\(.*\))/plugins=(\1 aliases command-not-found fzf history-substring-search magic-enter ssh sudo zsh-autosuggestions zsh-helix-mode)/' "$HOME/.zshrc"

##########
# FINISH #
##########

# change shell
chsh -s "$(command -v zsh)"

# echo
echo ""
echo "Setup done."
echo ""
echo "Press any key to exit."
read -n 1 -r -s
