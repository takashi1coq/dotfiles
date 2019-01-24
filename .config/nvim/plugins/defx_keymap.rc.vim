" set modifiable
setlocal nomodifiable

" defx key mapping
nnoremap <silent><buffer><expr> j line('.') == line('$') ? 'gg' : 'j'
nnoremap <silent><buffer><expr> k line('.') == 1 ? 'G' : 'k'
nnoremap <silent><buffer><expr> h defx#do_action('cd', ['..'])
nnoremap <silent><buffer><expr> l defx#do_action('open_directory')
nnoremap <silent><buffer><expr> <CR> defx#do_action('open', 'wincmd w \| drop'). '<C-w>w'. ':<C-u>q<CR>'
nnoremap <silent><buffer><expr> <C-t> defx#do_action('open', '$tabnew')
nnoremap <silent><buffer><expr> N defx#do_action('new_file')
nnoremap <silent><buffer><expr> D defx#do_action('new_directory')
nnoremap <silent><buffer><expr> r defx#do_action('rename')
nnoremap <silent><buffer><expr> dd defx#do_action('remove')
nnoremap <silent><buffer><expr> m defx#do_action('move')
nnoremap <silent><buffer><expr> p defx#do_action('paste')
nnoremap <silent><buffer><expr> n defx#do_action('toggle_select')
nnoremap <silent><buffer><expr> <ESC><ESC> ':<C-u>q<CR>'

" buffer chenge disable
nnoremap <buffer> <C-j> <Nop>
nnoremap <buffer> <C-k> <Nop>
