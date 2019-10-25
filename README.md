# dotfiles

### Arch NeoVim install

- `python-neovim` is python client
```
sudo pacman -S neovim
sudo pacman -S python2-neovim python-neovim
```

### install tools

- neovim clipboard (:h clipboard-tool)
- X WindowSystem requied (not required on server)
```
sudo pacman -S xsel
```

- trans google
```
git clone https://github.com/soimort/translate-shell
cd translate-shell/
make
sudo make install
```

- neovim-remote (nvr)
```
pip3 install neovim-remote
```

- words (check `look` is installed)
- look only works on `md` and `gitcommit`
```
sudo pacman -S words
```

### lsp install

- pythoh lsp (archlinux)
```
sudo pacman -S python-language-server
```

- javascript lsp (nodenv)
```
npm i -g javascript-typescript-langserver
exec -l $SHELL
```

- html lsp (nodenv)
```
npm i -g vscode-html-languageserver-bin
exec -l $SHELL
```

### setup

```
git clone https://github.com/takashi1coq/dotfiles dotfiles
sh ~/dotfiles/setup.sh
```

### for Mac

- System Preferences > Keyboard > Shortcuts > Locate "F11" and uncheck it for Show Desktop

- bashrc

```
echo 'exec $SHELL -l' > ~/.bahsrc
```

