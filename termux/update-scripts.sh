#!/bin/zsh
# shellcheck shell=bash

# update scripts and add new ones to zsh alias.
# required: git

# colors
LB='\e[1;34m' # light blue
R='\e[0m'     # no color

main() {
# remove old repo dir
rm -rf ~/.scripts

# clone repo
git clone --single-branch --branch main https://github.com/majinsaay/scripts.git ~/.scripts

# change working dir
cd "$HOME/.scripts/termux" || exit 1

# make executable
chmod u+x *

# scripts aliases block variables
BEGIN_MARKER="# === SCRIPTS ALIASES - BEGIN ==="
END_MARKER="# === SCRIPTS ALIASES - END ==="

# delete old block
sed -i "/$BEGIN_MARKER/,/$END_MARKER/d" ~/.zshrc

# generate new block beginning
cat >> "$HOME/.zshrc"<< EOF
# === SCRIPTS ALIASES - BEGIN ===

EOF

# make alias for each script
for i in *.sh; do
  echo -e "alias ${i%.sh}='. ~/.scripts/termux/$i'" >> ~/.zshrc
done

# close block
cat >> "$HOME/.zshrc"<< EOF

# === SCRIPTS ALIASES - END ===

EOF

##########
# FINISH #
##########

# return to home
cd "$HOME" || exit 1

# echo
echo ""
echo "${LB}Done"
echo ""
echo "${R}Press any key to exit..."
read -k 1 -r -s
}

main "$@"
return