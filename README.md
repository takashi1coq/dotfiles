# dotfiles

### install Homebrew

### brew install

```
brew install neovim
brew install deno
brew install anyenv
brew install ripgrep
```

### anyenv
```
anyenv init
anyenv install --init
* echo 'eval "$(anyenv init -)" >> ~~~'
```

### nodenv

```
anyenv install nodenv
nodenv install --list
nodenv install xx.xx.xx
nodenv global xx.xx.xx
```

### install yarn

```
npm install -g yarn
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
### Arch linux ...

- neovim clipboard (:h clipboard-tool)
- X WindowSystem requied (not required on server)
```
sudo pacman -S xsel
```
- words
```
sudo pacman -S words
```
