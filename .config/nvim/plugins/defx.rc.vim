" set modifiable
setlocal nomodifiable

" defx key mapping
nnoremap <silent><buffer><expr> j line('.') == line('$') ? 'gg' : 'j'
nnoremap <silent><buffer><expr> k line('.') == 1 ? 'G' : 'k'
nnoremap <silent><buffer><expr> h defx#do_action('cd', ['..'])
nnoremap <silent><buffer><expr> l defx#async_action('open')
nnoremap <silent><buffer><expr> N defx#do_action('new_file')
nnoremap <silent><buffer><expr> r defx#do_action('rename')
nnoremap <silent><buffer><expr> <ESC><ESC> defx#do_action('quit')
