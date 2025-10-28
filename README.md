# dotfiles

### install Homebrew

### brew install

- for mac
```
brew install neovim deno ripgrep
```
- for windows
```
winget install Git
winget install Neovim.Neovim
winget install DenoLand.Deno
winget install BurntSushi.ripgrep
```

### ssh-keygen

setting up ssh for github

```
ssh-keygen -t RSA -b 4096
```

### setup

on windows, run Administrator.

```
cd
git clone https://github.com/takashi1coq/dotfiles dotfiles
nvim --headless -c "lua dofile(vim.fn.expand('~/dotfiles/setup.lua'))" -c "qa"
```

### upgrade

for mac

```
brew update
brew upgrade
```

for windows

```
```

Depending on how it's installed,,

```
deno upgrade
```

