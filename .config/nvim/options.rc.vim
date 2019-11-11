" ==========================================================
"  options
" ==========================================================

" 行番号
set number

" スワップファイルを作成しない
set noswapfile

" undoFileを/tmpに作成
set undofile
set undodir=/tmp

" 大文字小文字を区別しない
set ignorecase

" * での検索や text-object 等での選択時に - で切らない
set iskeyword& iskeyword+=-

" jsonのダブルコーテーション表示用 非表示設定をすべてOFF
set conceallevel=0

" 一番したまでいったら上に戻る(検索)
set wrapscan

" エンコード
set fileencodings=utf-8,euc-jp,ucs-bom,iso-2022-jp,sjis,cp932,latin1

" ステータスライン
set statusline=%{getcwd()}%<\ %=[%{gina#component#repo#branch()}][%{&ft},%{&fenc},%{&ff}]\ %l/%L

" タブラインを常に表示
set showtabline=2

" タブライン作成
set tabline=%!MakeTabLine()

" クリップボード共有 Nvimの場合はxselが必須
if has("clipboard")
    set clipboard+=unnamedplus
endif

" <Tab> <Space> 等可視化
set list
set listchars=tab:>-,trail:_,extends:>,precedes:<

" <Tab>を<Space>2
set expandtab
set tabstop=2
set softtabstop=2
set shiftwidth=2

" カーソル行をハイライト
set cursorline

" 右にスプリット
set splitright

" 括弧のハイライトなくすために'pi_paren'無効
let loaded_matchparen = 1

" 同じファイルを複数タブで開かない用
au MyAutoCmd BufEnter *.* MakeWinOne

" ヘルプ開いたら移動
au MyAutoCmd BufEnter *.txt if &buftype == 'help' | execute 'TabSplit' | endif

" terminal start insert mode
if has('nvim')
    autocmd TermOpen term://* startinsert
endif

" markdownでエラーをハイライトしない
au MyAutoCmd FileType markdown hi link markdownError NONE

" ==========================================================
"  set FileType
" ==========================================================
au MyAutoCmd BufNewFile,BufRead *.toml set filetype=conf
au MyAutoCmd BufNewFile,BufRead *.yml set filetype=conf
au MyAutoCmd BufNewFile,BufRead *.vue set filetype=html
au MyAutoCmd BufNewFile,BufRead *.md set filetype=markdown
au MyAutoCmd BufNewFile,BufRead *.ts set filetype=typescript
au MyAutoCmd BufNewFile,BufRead *.tsx set filetype=typescript

" ==========================================================
"  dust
" ==========================================================

"ターミナル以外はバッファ開いたらパスをチェンジ
"au BufEnter * if &buftype !=# 'terminal' | execute 'lcd ' fnameescape(expand('%:p:h')) | endif

" マウス操作ON
"set mouse=a
