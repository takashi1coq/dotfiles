" set modifiable
setlocal nomodifiable

" open terminal remap
function! DefxTerminalSubWindow(context) abort
    let path = fnamemodify(a:context.targets[0], ':h')
    new
    execute ':lcd'. path
    terminal
endfunction

function! DefxTerminal(context) abort
    let path = fnamemodify(a:context.targets[0], ':h')
    execute ':lcd'. path
    Terminal
endfunction

nnoremap <buffer> <F11> <Nop>
nnoremap <silent><buffer><expr> <F11> defx#do_action('call', 'DefxTerminal')
nnoremap <buffer> <F12> <Nop>
nnoremap <silent><buffer><expr> <F12> defx#do_action('call', 'DefxTerminalSubWindow')

" defx key mapping
nnoremap <silent><buffer><expr> j line('.') == line('$') ? 'gg' : 'j'
nnoremap <silent><buffer><expr> k line('.') == 1 ? 'G' : 'k'
nnoremap <silent><buffer><expr> <C-k> defx#do_action('open_or_close_tree')
nnoremap <silent><buffer><expr> h defx#do_action('cd', ['..'])
nnoremap <silent><buffer><expr> l defx#do_action('open_directory')
nnoremap <silent><buffer><expr> <CR> defx#do_action('open', 'wincmd w \| drop'). '<C-w>w'. ':<C-u>q<CR>'
nnoremap <silent><buffer><expr> <C-t> defx#do_action('open', '$tabnew')
nnoremap <silent><buffer><expr> N defx#do_action('new_file')
nnoremap <silent><buffer><expr> . defx#do_action('new_file'). '.myroot<CR>'
nnoremap <silent><buffer><expr> D defx#do_action('new_directory')
nnoremap <silent><buffer><expr> r defx#do_action('rename')
nnoremap <silent><buffer><expr> dd defx#do_action('remove')
nnoremap <silent><buffer><expr> m defx#do_action('move')
nnoremap <silent><buffer><expr> p defx#do_action('paste')
nnoremap <silent><buffer><expr> n defx#do_action('toggle_select')
nnoremap <silent><buffer><expr> <ESC><ESC> ':<C-u>q<CR>'

" test code, show context
function! Test(context) abort
  echomsg string(a:context)
endfunction
nnoremap <silent><buffer><expr> ?
\ defx#do_action('call', 'Test')
