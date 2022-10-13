" set modifiable
setlocal nomodifiable

" open terminal remap
function! DefxTerminalSubWindow(context) abort
    let path = a:context.cwd
    new
    execute ':10wincmd_'
    execute ':lcd'. path
    terminal
endfunction

function! DefxTerminal(context) abort
    let path = a:context.cwd
    execute ':lcd'. path
    terminal
endfunction

nnoremap <buffer> <F11> <Nop>
nnoremap <silent><buffer><expr> <F11> defx#do_action('call', 'DefxTerminalSubWindow')
nnoremap <buffer> <F12> <Nop>
nnoremap <silent><buffer><expr> <F12> defx#do_action('call', 'DefxTerminal')

" defx key mapping
nnoremap <silent><buffer><expr> j line('.') == line('$') ? 'gg' : 'j'
nnoremap <silent><buffer><expr> k line('.') == 1 ? 'G' : 'k'
nnoremap <silent><buffer><expr> <C-k> defx#do_action('open_or_close_tree')
nnoremap <silent><buffer><expr> <C-a> defx#do_action('open_tree_recursive')
nnoremap <silent><buffer><expr> h defx#do_action('cd', ['..'])
nnoremap <silent><buffer><expr> l defx#do_action('open_directory')
nnoremap <silent><buffer><expr> <CR> defx#do_action('open'). ':<C-u>TabSplit<CR>'
nnoremap <silent><buffer><expr> N defx#do_action('new_multiple_files')
nnoremap <silent><buffer><expr> . defx#do_action('new_file'). '.myroot<CR>'
nnoremap <silent><buffer><expr> D defx#do_action('new_directory')
nnoremap <silent><buffer><expr> rr defx#do_action('rename')
nnoremap <silent><buffer><expr> dd defx#do_action('remove')
nnoremap <silent><buffer><expr> mm defx#do_action('move')
nnoremap <silent><buffer><expr> yy defx#do_action('copy')
nnoremap <silent><buffer><expr> p defx#do_action('paste')
nnoremap <silent><buffer><expr> n defx#do_action('toggle_select')
vnoremap <silent><buffer><expr> n defx#do_action('toggle_select_visual')
nnoremap <silent><buffer><expr> <ESC><ESC> ':<C-u>q<CR>'
