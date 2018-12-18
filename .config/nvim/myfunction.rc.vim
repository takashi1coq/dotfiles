" copy path
if exists("g:loaded_copypath")
    finish
endif

let g:loaded_copypath = 1

" if option is set then use open.
if !exists('g:copypath_copy_to_unnamed_register')
    let g:copypath_copy_to_unnamed_register = 0
endif

function CopyPath()
    let @+=expand('%:p')
    " copy unnamed register.
    if g:copypath_copy_to_unnamed_register
        let @"=expand('%:p')
    endif
endfunction

function CopyFileName()
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
