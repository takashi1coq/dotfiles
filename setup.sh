#!/bin/bash
DOT_FILES=( .config/nvim )

for file in ${DOT_FILES[@]}
do
    ln -s $HOME/dotfiles/$file $HOME/$file
done
