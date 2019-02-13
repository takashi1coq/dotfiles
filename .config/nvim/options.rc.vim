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
set statusline=[FORMAT=%{&ff}]\ [TYPE=%Y]\ [%{getcwd()}]\ [LOW=%l/%L]
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

" ---tabpage
" タブページを常に表示
set showtabline=2
" マウス操作ON
"set mouse=a
" tabline
set tabline=%!MakeTabLine()

" set filetype
au MyAutoCmd BufNewFile,BufRead *.toml setf conf
au MyAutoCmd BufNewFile,BufRead *.vue setf html
au MyAutoCmd BufRead,BufNewFile *.md set filetype=markdown
" x削除でレジスタに格納しない
nnoremap x "_x
" 括弧のハイライトなくす
let loaded_matchparen = 1
" 右にスプリット
set splitright

"ターミナル以外はバッファ開いたらパスをチェンジ
"au BufEnter * if &buftype !=# 'terminal' | execute 'lcd ' fnameescape(expand('%:p:h')) | endif
