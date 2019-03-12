function! DefxExplorer(str, min_w, max_w, tabflg)

    " 存在しない場合、homeを表示
    let l:dir = expand(a:str)
    if isdirectory(l:dir) == 0
        let l:dir = expand('~/')
    endif

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
    execute l:cmd. ' '. l:dir

endfunction

" current
nnoremap <silent> <Space>f :call DefxExplorer('%:p:h', 35, 35, 0)<CR>60<C-w><bar>
" work folder
nnoremap <silent> <Space>w :call DefxExplorer('~/work/', 60, 60, 1)<CR>

" icon
call defx#custom#column('filename', {
      \ 'directory_icon': '▸',
      \ 'opened_icon': '▾',
      \ 'root_icon': ' ',
      \ })

call defx#custom#column('mark', {
      \ 'readonly_icon': '✗',
      \ 'selected_icon': '✓',
      \ })
