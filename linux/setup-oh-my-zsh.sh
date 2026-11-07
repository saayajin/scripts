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
echo -e 'prompt_context() {\n  if [[ "$USER" != "$DEFAULT_USER" || -n "$SSH_CLIENT" ]]; then\n    prompt_segment black default "%(!.%{%F{yellow}%}.)$USER"\n  fi\n}\n' >> "$HOME/.zshrc"

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

# set chpwd hook
echo -e 'autoload zmv\n' >> "$HOME/.zshrc"

# finish
echo ""
echo "Done"
echo ""
echo "Press any key to exit."
read -n 1 -r -s
