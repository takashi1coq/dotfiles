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
"とにかくファイル開いたときにそのバッファのパスにチェンジする※最高
au BufEnter * execute 'lcd ' fnameescape(expand('%:p:h'))
" カーソル行をハイライト
set cursorline
" *でV選択を検索
vnoremap * "zy:let @/ = @z<CR>n
