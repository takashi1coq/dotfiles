" function loaded check うんcode
if exists("g:loaded_function")
    finish
endif

let g:loaded_function = 1

" ==========================================================
"  CopyPath & CopyFileName
" ==========================================================
function! CopyPath()
    let @+=expand('%:p')
    " copy unnamed register.
    if !has('clipboard')
        let @"=expand('%:p')
    endif
endfunction

function! CopyFileName()
    let @+=expand('%:t')
    " copy unnamed register.
    if !has('clipboard')
        let @"=expand('%:t')
    endif
endfunction

command! -nargs=0 CopyPath     call CopyPath()
command! -nargs=0 CopyFileName call CopyFileName()

" ==========================================================
"  unused space delete
" ==========================================================
command! EndSpaceDel :%s/\s\+$//ge


" ==========================================================
"  open excommond result whth new tabpage
" ==========================================================
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
    let l:res = C(join(a:args))
    MyTabNew
    silent put =l:res
    1,2delete _
endfunction

" ==========================================================
"  vimrc reload for dein
" ==========================================================
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
"

" ==========================================================
"  create tabline
" ==========================================================
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

" ==========================================================
"  MyTabNew うんcode
"  0:count
"  1:path
" ==========================================================
command! -nargs=* MyTabNew call s:both_ends_tabnew(<f-args>)

function! s:both_ends_tabnew(...)
    let l:res = ['$','']
    if a:0 >= 1
        let l:count = 0
        for n in a:000
            let res[l:count] = n
            let l:count += 1
        endfor
    endif
    if expand('%:p') !=# ''
        silent execute ':'. l:res[0]. 'tabnew' .l:res[1]
    endif
endfunction

" ==========================================================
"  open terminal whth new tabpage
" ==========================================================
command! -nargs=0 Terminal call s:my_terminal()

function! s:my_terminal()
    if (!exists('g:my_tabnew_terminal'))
        MyTabNew 0
        terminal
    else
        let wids = win_findbuf(g:my_tabnew_terminal)
        if empty(wids)
            MyTabNew 0
            terminal
        else
            call win_gotoid(wids[0])
        endif
    endif
    " うんcode
    let g:my_tabnew_terminal = bufnr("%")
endfunction

" ==========================================================
"  do not use file, Diff うんcode
" ==========================================================
command! -nargs=0 DiffNewFile :vs | enew | difft | wincmd w | difft | wincmd w

" ==========================================================
"  replace highlight
" ==========================================================
command! -nargs=1 ReplaceHihl call s:replace_hihl(<f-args>)

function! s:replace_hihl(word)
    silent execute ':%s//'. a:word. '/g'
endfunction

" ==========================================================
"  trans
" ==========================================================
command! -nargs=? JpEnTrans call s:jp_en_trans(<f-args>)

function! MyVisual()
    let [lnum1, col1] = getpos("'<")[1:2]
    let [lnum2, col2] = getpos("'>")[1:2]
    let lines = getline(lnum1, lnum2)
    if lnum1 == 0 && lnum2 == 0 && col1 == 0 && col2 == 0
        return ''
    endif
    let lines[-1] = lines[-1][:col2 - (&selection == 'inclusive' ? 1 : 2)]
    let lines[0] = lines[0][col1 - 1:]
    return join(lines, " ")
endfunction

function! s:jp_en_trans(...)
    let l:str = MyVisual()
    if a:0 >= 1
        let l:str = a:1
    endif
    echomsg system('trans -b -sl=en -tl=ja '. '"'. l:str. '"')
endfunction


