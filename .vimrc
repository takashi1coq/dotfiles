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
inoremap <C-v> <C-r>*
cnoremap <C-v> <C-r>*
" 進む、戻るを再マップ
nnoremap <C-o> <C-i>zz
nnoremap <C-i> <C-o>zz
" 閉じる
nnoremap q :<C-u>quit<CR>
" タブを全て閉じる
nnoremap to :<C-u>tabo<CR>
" copyPath
function! CopyPath()
  let l:path = expand('%:p')
  let l:path = substitute(l:path, getcwd(), '', 'g')
  let l:path = substitute(l:path, '^/', '', '')
  let @+=l:path
  " copy unnamed register.
  if !has('clipboard')
    let @"=l:path
  endif
  echomsg l:path
endfunction
command! -nargs=0 CopyPath     call CopyPath()
" copyFileName
function! CopyFileName()
  let @+=expand('%:t:r')
  " copy unnamed register.
  if !has('clipboard')
    let @"=expand('%:t:r')
  endif
  echomsg expand('%:t:r')
endfunction
command! -nargs=0 CopyFileName call CopyFileName()
