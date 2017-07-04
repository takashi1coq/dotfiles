"ノーマルモード時のみ;と:を入れ替える
nnoremap ; :
nnoremap : ;
"helpをqで閉じられるように
autocmd FileType help nnoremap <buffer> q <C-w>c
"コマンド履歴
nnoremap <sid>(command-line-enter) q:
nmap ;; <sid>(command-line-enter)
autocmd FileType vim nnoremap <buffer> q <C-w>c
"ウィドウ間の移動をswとする
nnoremap <C-w> <C-w>w
"新しいタブをtt
nnoremap tt :<C-u>tabnew<Cr>
"アクティブ以外閉じるをto
nnoremap to :<C-u>tabo<Cr>
"C-vで最新レジスタ貼り付け vim では*だった
noremap! <C-v> <C-r>+
"gfを必ず新しいタブで開く
nnoremap gf <C-w>gf
"aaで全選択
nmap <silent> aa ggVG$
"Rename
command! -nargs=1 -complete=file Rename f <args>|call delete(expand('#'))
"C-l,C-h,でタブ移動
nnoremap <silent> <c-l> gt
nnoremap <silent> <c-h> gT
"ハイライト解除
ret hlsearch
nnoremap <silent> <ESC><ESC> :nohlsearch<CR>
" x削除でレジスタに格納しない
nnoremap x "_x
" ビジュアルモードで選択した部分を*で検索できる
vnoremap * "zy:let @/ = @z<CR>n
" 末尾空白削除
command! EndSpaceDel :%s/\s\+$//ge
" 検索結果を真ん中
nmap n nzz
nmap N Nzz
nmap * *zz
nmap # #zz
" Ctrl-p で連続コピー
vnoremap <silent> <C-p> "0p<CR>

" terminal
tnoremap <silent> <ESC> <C-\><C-n>
