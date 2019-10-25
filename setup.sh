#!/bin/bash
function GitUserName() {

    echo 'git username?'
    read username

    if [ -z $username ]; then
        GitUserName
    fi
}
function GitEmail() {

    echo 'git email?'
    read email

    if [ -z $email ]; then
        GitEmail
    fi
}

DOT_FILES=( .config/nvim .gitconfig .gitignore_global .ctags .mybashrc )
mkdir -p $HOME/.config
mkdir -p $HOME/work/src
for file in ${DOT_FILES[@]}
do
    ln -sfn $HOME/dotfiles/$file $HOME/$file
done

touch ~/test.rc.vim

GitUserName
echo 'git username='$username
GitEmail
echo 'git email='$email

echo '[user]' > ~/.gitconfig.local
echo '    name = '$username >> ~/.gitconfig.local
echo '    email = '$email >> ~/.gitconfig.local

echo '[ source ~/.mybashrc ] in sh'
