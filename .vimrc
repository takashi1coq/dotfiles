" 行番号
set number
" スワップファイルを作成しない
set noswapfile
" 大文字小文字を区別しない
set ignorecase
" 一番下までいったら上に戻る(検索)
set wrapscan
" クリップボード共有
set clipboard+=unnamedplus
set clipboard+=unnamed
" タブスペース可視化
set list
set listchars=tab:>-,trail:_,extends:>,precedes:<
" <Tab>を<Space>2
set expandtab
set tabstop=2
set softtabstop=2
set shiftwidth=2

"n,vモード時のみ;と:を入れ替える
nnoremap ; :
nnoremap : ;
vnoremap ; :
vnoremap : ;
" 検索結果を真ん中へ
nmap n nzz
nmap N Nzz
nmap * *zz
nmap # #zz
" 削除でレジスタに格納しない
nnoremap x "_x
" wrap設定の場合、一行づつ移動する
nnoremap j gj
nnoremap k gk
" 移動
noremap H b
noremap L w
noremap J 13j
noremap K 13k
nnoremap <C-f> 13<C-e>
nnoremap <C-u> 13<C-y>
"C-l,C-h,でタブ移動
nnoremap <silent> <C-l> gt
nnoremap <silent> <C-h> gT
" aaで全選択
nmap <silent> aa ggVG$
" 貼り付け
noremap! <C-v> <C-r>*
