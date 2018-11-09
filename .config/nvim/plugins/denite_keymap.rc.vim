" current list
nnoremap <silent> <Space>u :<C-u>Denite file_rec buffer<CR>

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
nnoremap <silent> <Space>v :<C-u>Denite file_rec:~/.config/nvim -default-action=tabopen<CR>
" work list
nnoremap <silent> <Space>w :<C-u>Denite file_rec:~/work/src -default-action=tabopen<CR>

" list move
call denite#custom#map('insert', '<C-j>','<denite:move_to_next_line>', 'noremap')
call denite#custom#map('insert', '<C-k>','<denite:move_to_previous_line>', 'noremap')
" new tab open
call denite#custom#map('insert', '<C-t>','<denite:do_action:tabopen>')