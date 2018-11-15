"ノーマルモード時のみ;と:を入れ替える
nnoremap ; :
nnoremap : ;
"コマンド履歴
nnoremap <sid>(command-line-enter) q:
nmap ;; <sid>(command-line-enter)
autocmd FileType vim nnoremap <buffer> q <C-w>c
"helpもqで閉じられるように
autocmd FileType help nnoremap <buffer> q <C-w>c
"ウィドウ間の移動をwとする
nnoremap <C-w> <C-w>w
" ウィンドウ回転
nnoremap <silent>s <C-w>H
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
"C-l,C-h,でタブ移動
nnoremap <silent> <c-l> gt
nnoremap <silent> <c-h> gT
"esc2回でハイライト解除
ret hlsearch
nnoremap <silent> <ESC><ESC> :nohlsearch<CR>
" 検索結果を真ん中
nmap n nzz
nmap N Nzz
nmap * *zz
nmap # #zz
" Ctrl-p で差し替え後も連続コピー
vnoremap <silent> <C-p> "0p<CR>
" *でV選択を検索
vnoremap * "zy:let @/ = @z<CR>n
" terminal escでinsert modeから抜ける
tnoremap <silent> <ESC> <C-\><C-n>
" rootで上書き(設定ファイルなど) コマンドではないのでマップにする
cmap w!! w !sudo tee % > /dev/null
" 再読込
nnoremap <silent> <C-r> :source $MYVIMRC<CR>
