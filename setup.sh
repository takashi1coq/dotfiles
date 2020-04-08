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

DOT_FILES=( .config/nvim .gitconfig .gitignore_global .ctags .mybashrc )
mkdir -p $HOME/.config
mkdir -p $HOME/work/src
for file in ${DOT_FILES[@]}
do
  # -fnは上書きオプション
  ln -sfn $HOME/dotfiles/$file $HOME/$file
done

touch ~/test.rc.vim

GitUserName
GitEmail

echo '[user]' > ~/.gitconfig.local
echo '    name = '$username >> ~/.gitconfig.local
echo '    email = '$email >> ~/.gitconfig.local

echo 'create ~/.gitconfig.local'
echo 'username='$username
echo 'email='$email
echo ' set [ source ~/.mybashrc ] to shrc'
