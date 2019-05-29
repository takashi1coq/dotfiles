" current list
nnoremap <silent> <Space>u :<C-u>Denite file/rec -default-action=left_tabopen<CR>
" buffer list
nnoremap <silent> <Space>b :<C-u>Denite buffer -default-action=left_tabopen<CR>
" nvim cofig list
nnoremap <silent> <Space>v :<C-u>Denite file/rec:~/dotfiles -default-action=left_tabopen<CR>
" mark list
nnoremap <silent> <Space>m :<C-u>Denite mymarks:upper -default-action=left_tabopen<CR>
" menus list (rc)
nnoremap <silent> <Space>c :<C-u>Denite menu:rcs -default-action=left_tabopen<CR>

" grep
nnoremap <silent> <Space>g :<C-u>Denite grep -buffer-name=grep-buffer-denite<CR>
" visual grep
vnoremap <silent> <Space>g :<C-u>DeniteCursorWord grep -buffer-name=grep-buffer-denite<CR>
" grep buffer list
nnoremap <silent> <Space>r :<C-u>Denite -resume -buffer-name=grep-buffer-denite<CR>
" grep list jump
nnoremap <silent> <C-n> :<C-u>Denite -resume -buffer-name=grep-buffer-denite -select=+1 -immediately<CR>
nnoremap <silent> <C-b> :<C-u>Denite -resume -buffer-name=grep-buffer-denite -select=-1 -immediately<CR>

" list move
call denite#custom#map('insert', '<C-j>','<denite:move_to_next_line>', 'noremap')
call denite#custom#map('insert', '<C-k>','<denite:move_to_previous_line>', 'noremap')

" new tab open
" 調 denite#custom#actionのfunctionに引数渡す方法
function! LeftDeniteTabOpen(context) abort
    let l:mylist = []
    for target in a:context['targets']
        let l:path = target['action__path']
        if filereadable(expand(l:path))
            call add(l:mylist, l:path)
        endif
    endfor
    let l:str = join(l:mylist, ' ')
    silent execute ':MyTabNew 0 '.l:str
endfunction
call denite#custom#action('file,buffer,mark,menu',
                        \ 'left_tabopen',
                        \ 'LeftDeniteTabOpen',{'is_quit' : 'v:true'})
function! RightDeniteTabOpen(context) abort
    let l:mylist = []
    for target in a:context['targets']
        let l:path = target['action__path']
        if filereadable(expand(l:path))
            call add(l:mylist, l:path)
        endif
    endfor
    let l:str = join(l:mylist, ' ')
    silent execute ':MyTabNew '.'$' . ' '. l:str
endfunction
call denite#custom#action('file,buffer,mark,menu',
                        \ 'right_tabopen',
                        \ 'RightDeniteTabOpen', {'is_quit' : 'v:true'})
" new tab open keymap
call denite#custom#map('insert', '<C-t>','<denite:do_action:left_tabopen>')

" two buffer display side by side
function! MyDeniteSideBySide(context) abort
    let l:mylist = []
    for target in a:context['targets']
        let l:path = target['action__path']
        if filereadable(expand(l:path))
            call add(l:mylist, l:path)
        endif
    endfor
    let l:str = join(l:mylist, ' | vs ')
    execute ':-1tabnew '. l:str
endfunction
call denite#custom#action('file,buffer,mark', 'denite_side_by_side', 'MyDeniteSideBySide', {'is_quit' : 'v:true'})
call denite#custom#map('insert', '<C-w>','<denite:do_action:denite_side_by_side>')

" select
call denite#custom#map('insert', '<C-n>', '<denite:toggle_select>')
call denite#custom#map('insert', '<C-a>', '<denite:toggle_select_all>')

" buffer delete (error in file_rec)
call denite#custom#map('insert', '<C-d>', '<denite:do_action:delete>')
