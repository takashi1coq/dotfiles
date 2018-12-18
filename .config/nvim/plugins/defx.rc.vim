function! DefxExplorer(dir)
    let l:cmd = join([
        \ 'Defx',
        \ '-buffer-name=myDefx',
        \ '-show-ignored-files',
        \ '-split=horizontal',
        \ '-columns=git:mark:filename:type:time:size'
        \ ], ' ')
    execute l:cmd. ' '. a:dir
endfunction

" current
nnoremap <silent> <Space>f :call DefxExplorer("`expand('%:p:h')`")<CR>
" work folder
nnoremap <silent> <Space>w :call DefxExplorer("`expand('~/work/src')`")<CR>
