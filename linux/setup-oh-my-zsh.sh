#!/bin/bash

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
echo ""
echo "Setup done."
echo ""
echo "Press any key to exit."
read -n 1 -r -s
