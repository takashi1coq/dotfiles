function! DefxExplorer(dir, min_w, max_w, tabflg)

    let l:my_split = 'vertical'
    if a:tabflg
        let l:my_split = 'no'
        MyTabNew
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
nnoremap <silent> <Space>f :call DefxExplorer("`expand('%:p:h')`", 35, 35, 0)<CR>60<C-w><bar>
" work folder
nnoremap <silent> <Space>w :call DefxExplorer("`expand('~/work/')`", 60, 60, 1)<CR>

