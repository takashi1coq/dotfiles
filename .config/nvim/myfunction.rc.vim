" copy path
if exists("g:loaded_copypath")
    finish
endif

let g:loaded_copypath = 1

" if option is set then use open.
if !exists('g:copypath_copy_to_unnamed_register')
    let g:copypath_copy_to_unnamed_register = 0
endif

function! CopyPath()
    let @+=expand('%:p')
    " copy unnamed register.
    if g:copypath_copy_to_unnamed_register
        let @"=expand('%:p')
    endif
endfunction

function! CopyFileName()
    let @+=expand('%:t')
    " copy unnamed register.
    if g:copypath_copy_to_unnamed_register
        let @"=expand('%:t')
    endif
endfunction

command! -nargs=0 CopyPath     call CopyPath()
command! -nargs=0 CopyFileName call CopyFileName()

" いらない空白削除コマンド
command! EndSpaceDel :%s/\s\+$//ge

" Capture コマンド実行結果をキャプチャー {{{
command!
    \ -nargs=+
    \ -complete=command
    \ Capture
    \ call s:cmd_capture([<f-args>])

function! C(cmd)
    redir => result
    silent execute a:cmd
    redir END
    return result
endfunction

function! s:cmd_capture(args)
    $tabnew
    silent put =C(join(a:args))
    1,2delete _
endfunction
" }}}

" 再読込 {{{
if has('vim_starting')
    command!
        \ -nargs=0
        \ -complete=command
        \ ReloadMYVIMRC
        \ call s:myvimrc_refresh()

    function! s:myvimrc_refresh()
        source $MYVIMRC
        call dein#recache_runtimepath()
    endfunction
endif
" }}}

" tabline {{{
function! s:tabpage_label(n)
    let title = gettabvar(a:n, 'title')
    if title !=# ''
        retrun title
    endif

    " tabpage内のバッファリスト
    let bufnrs = tabpagebuflist(a:n)

    " カレントタブページかどうかでハイライトを切り替える
    let hi = a:n is tabpagenr() ? '%#TabLineSel#' : '%#TabLine#'

    " tabpage内に変更中のバッファがあれば'+'をつける
    let mod = len(filter(copy(bufnrs), 'getbufvar(v:val, "&modified")')) ? '+' : ''
    let sp = mod ==# '' ? '' : ' ' " 隙間開ける

    let curbufnr = bufnrs[tabpagewinnr(a:n) - 1] " tabpagewinnr() は 1 origin
    let filename = fnamemodify(bufname(curbufnr), ':t')

    " カレントの前後でなければファイル名を'-'とする
    if (a:n < tabpagenr() - 1 || a:n > tabpagenr() + 1)
        let filename = '-'
    endif

    " 無題設定
    let filename = filename ==# '' ? 'NO NAME' : filename

    let label = ' '. mod. sp. filename. ' '

    return '%'. a:n. 'X'. hi. label. '%X%#TabLineFill#'

endfunction

function! MakeTabLine()
    let titles = map(range(1, tabpagenr('$')), 's:tabpage_label(v:val)')
    let sep = ' ' "タブ間の区切り
    let tabpages = join(titles, sep). sep. '%#TabLineFill#%T'
    let info = expand('%:p:h') " タブ情報
    return tabpages. '%='. info
endfunction
" }}}

" tabnew うんcode
command! -nargs=? MyTabNew call s:my_tabnew(<f-args>)

function! s:my_tabnew(...)
    let path = ''
    if a:0 >= 1
        let path = a:1
    endif
    if expand('%:p') !=# ''
        silent execute ':$tabnew '. path
    endif
endfunction

" terminal
command! -nargs=0 Terminal call s:my_terminal()

function! s:my_terminal()
    MyTabNew
    terminal
endfunction
