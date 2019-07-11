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
    echomsg expand('%:p')
endfunction

function! CopyFileName()
    let @+=expand('%:t')
    " copy unnamed register.
    if !has('clipboard')
        let @"=expand('%:t')
    endif
    echomsg expand('%:t')
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
"    if (a:n < tabpagenr() - 1 || a:n > tabpagenr() + 1)
"        let filename = '-'
"    endif

    " 無題設定
    let filename = filename ==# '' ? 'NO NAME' : filename

    let label = ' '. mod. sp. filename. ' '

    return '%'. a:n. 'X'. hi. label. '%X%#TabLineFill#'

endfunction

function! MakeTabLine()
    let titles = map(range(1, tabpagenr('$')), 's:tabpage_label(v:val)')
    let sep = ' ' "タブ間の区切り
    let tabpages = join(titles, sep). sep. '%#TabLineFill#%T'
    let info = '' " タブ情報
    return tabpages. '%='. info
endfunction

" ==========================================================
"  MyTabNew うんこ
"  0:count
"  1:path
" ==========================================================
command! -nargs=* MyTabNew call s:both_ends_tabnew(<f-args>)

function! s:both_ends_tabnew(...)
    let l:res = []
    if a:0 >= 1
        if filereadable(expand(a:000[0]))
            call add(l:res, '0')
        endif
        for n in a:000
            call add(l:res, n)
        endfor
    else
        call add(l:res, '0')
    endif
    let num = l:res[0]
    unlet l:res[0]
    if len(l:res) != 0
        for path in l:res
            if expand('%:p') !=# ''
                silent execute ':'. l:num. 'tabnew ' .path
            else
                silent execute ':e'.path
            endif
        endfor
    else
        if expand('%:p') !=# ''
            silent execute ':'. l:num. 'tabnew'
        endif
    endif
endfunction

" ==========================================================
"  open terminal whth new tabpage
" ==========================================================
command! -nargs=0 Terminal call s:my_terminal()

function! s:my_terminal()
    if (!exists('g:my_tabnew_terminal'))
        MyTabNew $
        terminal
    else
        let wids = win_findbuf(g:my_tabnew_terminal)
        if empty(wids)
            MyTabNew $
            terminal
        else
            call win_gotoid(wids[0])
        endif
    endif
    " うんcode
    let g:my_tabnew_terminal = bufnr("%")
endfunction

" ==========================================================
"  DiffNewFile
" ==========================================================
command! -nargs=0 DiffNewFile :vertical diffsplit /tmp/mydiff

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

" ==========================================================
"  make window one
" ==========================================================
command! -nargs=0 MakeWinOne call s:win_one()

function! s:win_one()
    let winr = win_getid()
    let winr_list = win_findbuf(bufnr('%'))

    for dup_winr in winr_list
        if dup_winr != winr
            call win_gotoid(dup_winr)
            quit
        endif
    endfor
    call win_gotoid(winr)
endfunction

" ==========================================================
"  tab sp
" ==========================================================
command! -nargs=0 TabSplit call s:tab_sp()

function! s:tab_sp()
    execute '0tab split'
    execute 'MakeWinOne'
endfunction

" ==========================================================
"  ファイルの存在しないバッファを閉じる
" ==========================================================
command! -bar RefreshFiles call s:refresh_files()

function! s:refresh_files()

    " refresh tabpage
    let save_tab = tabpagenr()
    let save_win = winnr()
    execute 'tabdo e!'
    execute 'tabnext '. save_tab
    execute save_win. ' wincmd w'

    " delete no file buffer
    let list = filter(range(1, bufnr("$")),
\        'bufexists(bufname(v:val)) && !filereadable(expand("#".v:val.":p")) && buflisted(v:val)'
\    )
    for v in list
        if getbufvar(v, '&buftype') != 'terminal'
            execute "bd ".v
        endif
    endfor

endfunction

" ==========================================================
"  echo $PATH
" ==========================================================
command! -bar EchoPath call s:echo_path()

function! s:echo_path()
    silent execute 'Capture !echo $PATH'
    silent execute '%s/://g'
endfunction

" ==========================================================
"  my quit
" ==========================================================
command! -bar MyQuit call s:my_quit()

function! s:my_quit()
    let path = expand('%:p')
    if l:path ==# ''
        silent execute 'quit!'
    else
        if &diff
            silent execute 'tabc'
        else
            silent execute 'wincmd c'
        endif
    endif
endfunction
