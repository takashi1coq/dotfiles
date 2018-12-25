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
    tabnew
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

