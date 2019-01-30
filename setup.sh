#!/bin/bash
DOT_FILES=( .config/nvim .gitconfig .gitignore_global .ctags )
mkdir -p $HOME/.config
mkdir -p $HOME/work/src
for file in ${DOT_FILES[@]}
do
    ln -sfn $HOME/dotfiles/$file $HOME/$file
done

touch ~/test.rc.vim
