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

" <Tab>を<Space>4
set expandtab
set tabstop=4
set softtabstop=4
set shiftwidth=4

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

" markdownでアンダーバーをエラーにしない
au FileType markdown syn clear markdownError

" ==========================================================
"  set FileType
" ==========================================================
au MyAutoCmd BufNewFile,BufRead *.toml setf conf
au MyAutoCmd BufNewFile,BufRead *.yml setf conf
au MyAutoCmd BufNewFile,BufRead *.vue setf html
au MyAutoCmd BufNewFile,BufRead *.md setf markdown
au MyAutoCmd BufNewFile,BufRead *.ts setf typescript
au MyAutoCmd BufNewFile,BufRead *.tsx setf typescript

" ==========================================================
"  dust
" ==========================================================

"ターミナル以外はバッファ開いたらパスをチェンジ
"au BufEnter * if &buftype !=# 'terminal' | execute 'lcd ' fnameescape(expand('%:p:h')) | endif

" マウス操作ON
"set mouse=a
