" 行番号
set number
" スワップファイルを作成しない
set noswapfile
" 折り返さない
set nowrap
" undoFileを/tmpに作成
set undofile
set undodir=/tmp
" 大文字小文字を区別しない
set ignorecase
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

"ターミナル以外はバッファ開いたらパスをチェンジ
au BufEnter * if &buftype !=# 'terminal' | execute 'lcd ' fnameescape(expand('%:p:h')) | endif
" set filetype
au BufNewFile,BufRead *.toml setf conf
au BufNewFile,BufRead *.vue setf html
" x削除でレジスタに格納しない
nnoremap x "_x
