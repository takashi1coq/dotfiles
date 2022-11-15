# dotfiles

### install env

- anyenv
  - see anyenv wiki ...
- any env
```
anyenv install pyenv
anyenv install nodenv
anyenv install phpenv
```

### install yarn

```
npm install -g yarn
```

### neovim install

see neovim wiki..

- neovim-remote (nvr)
- pynvim
```
pip install pynvim neovim-remote
```


### install tools

- trans google
```
git clone https://github.com/soimort/translate-shell
cd translate-shell/
make
sudo make install
```
- words (check `look` is installed)
  - look only works on `md` and `gitcommit`

### setup

```
git clone https://github.com/takashi1coq/dotfiles dotfiles
sh ~/dotfiles/setup.sh
```
### Mac

- System Preferences > Keyboard > Shortcuts > Locate "F11" and uncheck it for Show Desktop

### Arch linux

- neovim clipboard (:h clipboard-tool)
- X WindowSystem requied (not required on server)
```
sudo pacman -S xsel
```
- words
```
sudo pacman -S words
```
