"各種設定
set number
set noswapfile
set nowrap
set undofile
set undodir=/tmp
"エンコーディング
set fileencodings=utf-8,euc-jp,ucs-bom,iso-2022-jp,sjis,cp932,latin1
"ステータスライン
set statusline=%F%m%r%h%w\ [FORMAT=%{&ff}]\ [TYPE=%Y]\ [%{getcwd()}]
"クリップボード共有 Nvimの場合はxselが必須
set clipboard+=unnamedplus
"タブもろもろ可視化
set list
set listchars=tab:>-,trail:_,extends:>,precedes:<
"タブをスベース4
set expandtab
set tabstop=4
set softtabstop=4
set shiftwidth=4
" カーソル行をハイライト
set cursorline

"とにかくファイル開いたときにそのバッファのパスにチェンジする
au BufEnter * execute 'lcd ' fnameescape(expand('%:p:h'))
" set filetype
au BufNewFile,BufRead *.toml setf conf
au BufNewFile,BufRead *.vue setf html
"Rename コマンド
command! -nargs=1 -complete=file Rename f <args>|call delete(expand('#'))
" x削除でレジスタに格納しない
nnoremap x "_x
" いらない空白削除コマンド
command! EndSpaceDel :%s/\s\+$//ge
