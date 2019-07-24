"kopipe. use ag
if executable('ag')
    call denite#custom#var('file/rec', 'command', ['ag', '--follow', '--nocolor', '--nogroup', '-g', ''])
    call denite#custom#var('grep', 'command', ['ag'])
    call denite#custom#var('grep', 'recursive_opts', [])
    call denite#custom#var('grep', 'pattern_opt', [])
    call denite#custom#var('grep', 'default_opts', ['--follow', '--no-group', '--no-color'])
endif

" customize ignore globs
call denite#custom#source('file/rec','matchers',['matcher_fuzzy','matcher/ignore_globs'])
call denite#custom#filter('matcher/ignore_globs','ignore_globs',
        \ [
        \ '.git/', 'build/', '__pycache__/', 'node_modules/', '.node-version',
        \ 'images/', 'img/',
        \ '*.o', '*.make', '.myroot' ])

" menus
let s:menus = {}

let s:menus.rcs = {
    \ 'description': 'create rc menus'
    \ }
let s:menus.rcs.file_candidates = [
    \ ['bashrc', '~/.bashrc'],
    \ ['bash profile', '~/.bash_profile'],
    \ ['etc profile (read only)', '/etc/profile'],
    \ ['gitconfig local', '~/.gitconfig.local'],
    \ ['ssh config', '~/.ssh/config'],
    \ ['test vimrc', '~/test.rc.vim'],
    \ ]

"let s:menus.my_commands = {
"    \ 'description': 'Example commands'
"    \ }
"let s:menus.my_commands.command_candidates = [
"    \ ['Split the window', 'vnew'],
"    \ ['Open config menu', 'Denite menu:config'],
"    \ ]

call denite#custom#var('menu', 'menus', s:menus)

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
call denite#custom#action('file,buffer,mark',
                        \ 'denite_side_by_side',
                        \ 'MyDeniteSideBySide', {'is_quit' : 'v:true'})

" current list
nnoremap <silent> <Space>u :<C-u>Denite file/rec
                    \ -default-action=left_tabopen
                    \ -start-filter<CR>
" buffer list
nnoremap <silent> <Space>b :<C-u>Denite buffer
                    \ -default-action=denite_side_by_side<CR>
" nvim cofig list
nnoremap <silent> <Space>v :<C-u>Denite file/rec:~/dotfiles
                    \ -default-action=left_tabopen
                    \ -start-filter<CR>
" mark list
nnoremap <silent> <Space>m :<C-u>Denite mymarks:upper
                    \ -default-action=left_tabopen<CR>
" menus list (rc)
nnoremap <silent> <Space>c :<C-u>Denite menu:rcs
                    \ -default-action=left_tabopen<CR>

" grep
nnoremap <silent> <Space>g :<C-u>Denite grep
                    \ -buffer-name=grep-buffer-denite<CR>
" visual grep
vnoremap <silent> <Space>g :<C-u>DeniteCursorWord grep
                    \ -buffer-name=grep-buffer-denite<CR>
" grep buffer list
nnoremap <silent> <Space>r :<C-u>Denite
                    \ -resume
                    \ -buffer-name=grep-buffer-denite<CR>
" grep list jump
nnoremap <silent> <C-n> :<C-u>Denite
                    \ -resume
                    \ -buffer-name=grep-buffer-denite
                    \ -cursor-pos=+1
                    \ -immediately<CR>
nnoremap <silent> <C-b> :<C-u>Denite
                    \ -resume
                    \ -buffer-name=grep-buffer-denite
                    \ -cursor-pos=-1
                    \ -immediately<CR>

" denite-filter keymap
autocmd FileType denite-filter call s:denite_filter_my_settings()
function! s:denite_filter_my_settings() abort
    inoremap <silent><buffer><expr> <Esc><Esc> denite#do_map('quit')
"    imap <buffer> <Esc><Esc> <Plug>(denite_filter_quit)
"    nmap <buffer> <Esc> <Plug>(denite_filter_quit)
endfunction
