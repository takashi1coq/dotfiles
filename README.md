# dotfiles

### Arch NeoVim インストール

- `python-neovim`も同時にインストール

```
sudo pacman -S neovim
sudo pacman -S python2-neovim python-neovim
```

- neovim クリップボード

```
sudo pacman -S xsel
```
http://chakku.hatenablog.com/entry/2015/12/03/004348

- trans google
```
git clone https://github.com/soimort/translate-shell
cd translate-shell/
make
sudo make install
```

- neovim-remote
```
pip3 install neovim-remote
```

### セットアップ

```
git clone https://github.com/takashi1coq/dotfiles dotfiles
sh ~/dotfiles/setup.sh
```

