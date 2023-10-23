#!/bin/bash
function GitUserName() {

  read -p 'git username?' username

  if [ -z $username ]; then
      GitUserName
  fi
}
function GitEmail() {

  read -p 'git email?' email

  if [ -z $email ]; then
      GitEmail
  fi
}

DOT_FILES=( .config/nvim .gitconfig .gitignore_global .ctags .myshrc .vimrc )
mkdir -p $HOME/.config
mkdir -p $HOME/work/src
mkdir -p $HOME/work/compile
for file in ${DOT_FILES[@]}
do
  # -fnは上書きオプション
  ln -sfn $HOME/dotfiles/$file $HOME/$file
done

touch ~/.config/nvim/lua/local.lua

GitUserName
GitEmail

echo '[user]' > ~/.gitconfig.local
echo '    name = '$username >> ~/.gitconfig.local
echo '    email = '$email >> ~/.gitconfig.local

echo 'create ~/.gitconfig.local'
echo 'username='$username
echo 'email='$email
echo 'echo "source ~/.myshrc" >> .zshrc'
