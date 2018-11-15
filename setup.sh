#!/bin/bash
DOT_FILES=( .config/nvim .gitconfig .gitignore_global .ctags )

for file in ${DOT_FILES[@]}
do
    ln -sfn $HOME/dotfiles/$file $HOME/$file
done

touch ~/test.rc.vim
