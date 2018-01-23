# dotfiles

### Arch NeoVim インストール

- `pip`は使用しないこと`pacman`でインストールする

```
sudo pacman -S neovim
sudo pacman -S python2-neovim python-neovim
```

- neovim クリップボード

```
sudo pacman -S xsel
```
http://chakku.hatenablog.com/entry/2015/12/03/004348

### セットアップ

```
git clone https://github.com/takashi1coq/dotfiles dotfiles
sh ~/dotfiles/setup.sh
```

