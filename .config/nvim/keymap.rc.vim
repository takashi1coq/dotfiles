" ==========================================================
"  window
" ==========================================================

"ウィドウ間の移動をwとする
nnoremap <C-w> <C-w>w

" ウィンドウ回転
nnoremap <silent>s <C-w>H

" ==========================================================
"  tabpage
" ==========================================================

"新しいタブをtt
nnoremap <silent> tt :<C-u>$tabnew<CR>

"アクティブ以外閉じるをto
nnoremap to :<C-u>tabo<Cr>

"windowごとタブを閉じる
nnoremap tq :<C-u>tabc<Cr>

"gfを必ず新しいタブで開く
nnoremap gf <C-w>gf

"C-l,C-h,でタブ移動
nnoremap <silent> <c-l> gt
nnoremap <silent> <c-h> gT

"C-l,C-h,でタブそのものを移動
nnoremap <silent> <F9> :<C-u>tabm -1<CR>
nnoremap <silent> <F10> :<C-u>tabm +1<CR>

" ==========================================================
"  buffer
" ==========================================================

" バッファ前後切り替え
nnoremap <silent> <C-j> :silent bprev<CR>
nnoremap <silent> <C-k> :silent bnext<CR>

" バッファのみ閉じる（window,tabpegeに影響なし）
nnoremap <silent> bq :<C-u>bp<bar>sp<bar>bn<bar>bd<CR>

" ==========================================================
"  terminal
" ==========================================================

" terminal起動 (メイン)
nnoremap <silent> <F11> :Terminal<CR>

" terminal起動 (サブ)
nnoremap <silent> <F12> :sp<CR>:terminal<CR>5<C-w>_

" terminal escでinsert modeから抜ける
tnoremap <silent> <ESC> <C-\><C-n>

" ==========================================================
"  others
" ==========================================================

"n,vモード時のみ;と:を入れ替える
nnoremap ; :
nnoremap : ;
vnoremap ; :
vnoremap : ;

"コマンド履歴
nnoremap <sid>(command-line-enter) q:
nmap ;; <sid>(command-line-enter)
autocmd MyAutoCmd FileType vim nnoremap <buffer> q <C-w>c

"helpもqで閉じられるように
autocmd MyAutoCmd FileType help nnoremap <buffer> q <C-w>c

" C-vで最新レジスタ貼り付け
if has('clipboard')
    " vim では*
    noremap! <C-v> <C-r>+
else
    noremap! <C-v> <C-r>"
endif

" コード変換モード
noremap! <C-t> <C-v>

"aaで全選択
nmap <silent> aa ggVG$

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

" x削除でレジスタに格納しない
nnoremap x "_x

" *で単語検索
vnoremap * "zy:let @/ = @z<CR>n

" ==========================================================
"  dangerous
" ==========================================================

" rootで上書き(設定ファイルなど) コマンドではないのでマップにする
cmap w!! w !sudo tee % > /dev/null

" 再読込
nnoremap <silent> <F2> :ReloadMYVIMRC<CR>

" 日本語訳
vnoremap <silent> <Space><Space> :w !trans -b -sl=en -tl=ja<CR>
