function! DefxExplorer(dir, max_w, min_w, tabflg)

    let l:my_split = 'vertical'
    if a:tabflg
        let l:my_split = 'no'
        if expand('%:p') !=# ''
            $tabnew
        endif
    endif

    call defx#custom#column('filename', {
          \ 'min_width': a:min_w,
          \ 'max_width': a:max_w,
          \ })

    let l:cmd = join([
        \ 'Defx',
        \ '-buffer-name=myDefx',
        \ '-show-ignored-files',
        \ '-split='. l:my_split,
        \ '-columns=git:mark:filename:type:time'
        \ ], ' ')
    execute l:cmd. ' '. a:dir

endfunction

" current
nnoremap <silent> <Space>f :call DefxExplorer("`expand('%:p:h')`", 35, 35, 0)<CR>
" work folder
nnoremap <silent> <Space>w :call DefxExplorer("`expand('~/work/src')`", 60, 60, 1)<CR>

