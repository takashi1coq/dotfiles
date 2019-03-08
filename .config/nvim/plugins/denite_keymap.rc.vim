" current list
nnoremap <silent> <Space>u :<C-u>Denite file_rec<CR>
" buffer list
nnoremap <silent> <Space>b :<C-u>Denite buffer<CR>

" grep
nnoremap <silent> <Space>g :<C-u>Denite grep -buffer-name=grep-buffer-denite<CR>
" visual grep
vnoremap <silent> <Space>g :<C-u>DeniteCursorWord grep -buffer-name=grep-buffer-denite<CR>
" grep buffer list
nnoremap <silent> <Space>r :<C-u>Denite -resume -buffer-name=grep-buffer-denite<CR>
" grep list jump
nnoremap <silent> <C-n> :<C-u>Denite -resume -buffer-name=grep-buffer-denite -select=+1 -immediately<CR>
nnoremap <silent> <C-b> :<C-u>Denite -resume -buffer-name=grep-buffer-denite -select=-1 -immediately<CR>

" nvim cofig list
nnoremap <silent> <Space>v :<C-u>Denite file_rec:~/dotfiles<CR>

" list move
call denite#custom#map('insert', '<C-j>','<denite:move_to_next_line>', 'noremap')
call denite#custom#map('insert', '<C-k>','<denite:move_to_previous_line>', 'noremap')

" new tab open
call denite#custom#map('insert', '<C-t>','<denite:do_action:my_tabopen>')
call denite#custom#action('file,buffer', 'my_tabopen', 'MyDeniteTabOpen', {'is_quit' : 'v:true'})
function! MyDeniteTabOpen(context) abort
    for target in a:context['targets']
        let l:path = target['action__path']
        if filereadable(l:path)
            silent execute ':MyTabNew $ '. l:path
        endif
    endfor
endfunction

" display buffer side by side
call denite#custom#map('insert', '<C-w>','<denite:do_action:denite_side_by_side>')
call denite#custom#action('file,buffer', 'denite_side_by_side', 'MyDeniteSideBySide', {'is_quit' : 'v:true'})
function! MyDeniteSideBySide(context) abort
    let l:mylist = []
    for target in a:context['targets']
        let l:path = target['action__path']
        if filereadable(l:path)
            call add(l:mylist, l:path)
        endif
    endfor
    let l:str = join(l:mylist, ' | vs ')
    execute ':$tabnew '. l:str
endfunction


" select
call denite#custom#map('insert', '<C-n>', '<denite:toggle_select>')
call denite#custom#map('insert', '<C-a>', '<denite:toggle_select_all>')

" buffer delete (error in file_rec)
call denite#custom#map('insert', '<C-d>', '<denite:do_action:delete>')
