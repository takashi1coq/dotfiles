" ==========================================================
"  window
" ==========================================================

" ウィドウ間の移動
nnoremap <C-w> <C-w>w
" 再マップ
nnoremap <C-e> <C-w>

" 回転
nnoremap <silent>s <C-w>H

" サイズ変更
nnoremap <Up> <C-w>-
nnoremap <Down> <C-w>+
nnoremap <Right> <C-w><
nnoremap <Left> <C-w>>

" 閉じる
nnoremap q <C-w>c

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
nnoremap gf <C-w>gf:<C-u>tabm $<CR>

"C-l,C-h,でタブ移動
nnoremap <silent> <C-l> gt
nnoremap <silent> <C-h> gT

"<F9>,<F10>,でタブそのものを移動
nnoremap <silent> <F9> :<C-u>tabm -1<CR>
nnoremap <silent> <F10> :<C-u>tabm +1<CR>

" 新しいタブで開きなおす
nnoremap <silent> ts :TabSplit<CR>

" ==========================================================
"  buffer
" ==========================================================

" バッファ前後切り替え
nnoremap <silent> <C-j> :silent bprev<CR>
nnoremap <silent> <C-k> :silent bnext<CR>

" バッファのみ閉じる（window,tabpegeに影響なし）
nnoremap <silent> bd :<C-u>bp<bar>sp<bar>bn<bar>bd<bar>tabc<CR>

" ==========================================================
"  terminal
" ==========================================================

" メイン
nnoremap <silent> <F11> :Terminal<CR>

" サブ
nnoremap <silent> <F12> :sp<CR>:terminal<CR>10<C-w>_

" escでinsert modeから抜ける
tnoremap <silent> <ESC> <C-\><C-n>

" 貼り付け
tnoremap <silent> <C-v> <C-\><C-n>pi

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

"検索履歴
nnoremap <sid>(search-line-enter) q/
nmap // <sid>(search-line-enter)

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

" wrap設定の場合、一行づつ移動する
nnoremap j gj
nnoremap k gk

" 進む、戻るを再マップ
nnoremap <C-Right> <C-i>zz
nnoremap <C-Left> <C-o>zz

" ==========================================================
"  dangerous
" ==========================================================

" rootで上書き(設定ファイルなど) コマンドではないのでマップにする
cmap w!! w !sudo tee % > /dev/null

" 再読込
nnoremap <silent> <F2> :ReloadMYVIMRC<CR>

" 日本語訳
vnoremap <F1> :<C-u>JpEnTrans<CR>

" ファイル再読み込み (git stash 苦肉)
nnoremap <silent> <F5> :tabdo !e<CR><bar>:DeleteNoFileBuffer<CR>

