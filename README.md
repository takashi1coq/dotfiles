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

### coc

##### python

- black (cord format)
```
pip install black
```

##### ruby

- solargraph
```
gem install solargraph
```

### setup

```
git clone https://github.com/takashi1coq/dotfiles dotfiles
sh ~/dotfiles/setup.sh
```

### for Mac

- System Preferences > Keyboard > Shortcuts > Locate "F11" and uncheck it for Show Desktop

- create bashrc

```
echo 'exec $SHELL -l' > ~/.bahsrc
```

