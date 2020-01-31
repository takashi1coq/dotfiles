
" defx stert function
function! DefxExplorer(str, min_w, max_w, my_sprit)

    " 存在しない場合、homeを表示
    let l:dir = fnamemodify(expand(a:str), ":h")
    if isdirectory(l:dir) == 0
        let l:dir = expand('~/')
    endif

    let l:sprit = a:my_sprit
    if a:my_sprit == 'mytab'
        let l:sprit = 'no'
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
        \ '-split='. l:sprit,
        \ '-columns=indent:icon:mark:filename:type:time',
        \ '-search='. expand(a:str)
        \ ], ' ')
    execute l:cmd. ' '. l:dir

endfunction

" current
nnoremap <silent> <Space>f :call DefxExplorer('%:p', 35, 35, 'vertical')<CR>:60wincmd<bar><CR>
nnoremap <silent> F :call DefxExplorer('%:p:h', 60, 60, 'mytab')<CR>
" work folder
nnoremap <silent> <Space>w :call DefxExplorer('~/work/', 60, 60, 'mytab')<CR>
" others
command! -nargs=1 MyDefx call DefxExplorer(<f-args>, 60, 60, 'no')


" icon
call defx#custom#column('icon', {
      \ 'directory_icon': '▸',
      \ 'opened_icon': '▾',
      \ 'root_icon': ' ',
      \ })

" mark
call defx#custom#column('mark', {
      \ 'readonly_icon': '✗',
      \ 'selected_icon': '✓',
      \ })

" indent
call defx#custom#column('indent', {
      \ 'indent': '   ',
      \ })

