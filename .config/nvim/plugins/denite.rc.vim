"use rg
if executable('rg')
    call denite#custom#var('file/rec', 'command', ['rg', '--files', '-g', '!.git', '--hidden'])
    call denite#custom#var('grep', 'command', ['rg', '--threads', '1', '--hidden'])
    call denite#custom#var('grep', 'recursive_opts', [])
    call denite#custom#var('grep', 'final_opts', [])
    call denite#custom#var('grep', 'separator', ['--'])
    call denite#custom#var('grep', 'default_opts', ['-i', '--vimgrep', '--no-heading'])
endif

" customize ignore globs
call denite#custom#source('file/rec','matchers',['converter/tail_path','matcher/fuzzy','matcher/ignore_globs'])
call denite#custom#filter('matcher/ignore_globs','ignore_globs',
        \ [
        \ '.git/', 'build/', '__pycache__/', 'node_modules/', '.node-version',
        \ 'images/', 'img/',
        \ '*.o', '*.make', '.myroot' ])

" menus
let s:menus = {}

let s:menus.my_setting_files = {
    \ 'description': 'Setting Files Menu'
    \ }
let s:menus.my_setting_files.file_candidates = [
    \ ['File : ~/.bashrc', '~/.bashrc'],
    \ ['File : ~/.bash_profile', '~/.bash_profile'],
    \ ['File : ~/.zshrc', '~/.zshrc'],
    \ ['File : ~/.gitconfig.local', '~/.gitconfig.local'],
    \ ['File : ~/.ssh/config', '~/.ssh/config'],
    \ ['File : ~/local.rc.vim', '~/local.rc.vim'],
    \ ['File : /etc/profile (read only)', '/etc/profile'],
    \ ['File : /etc/hosts (read only)', '/etc/hosts'],
    \ ]

let s:menus.dein = {
    \ 'description': 'Plugin Management'
    \ }
let s:menus.dein.command_candidates = [
    \ ['Dein : Dein Plugin List', 'Denite dein -split=floating'],
    \ ['Dein : ★ Dein Plugin Update', 'call dein#update()'],
    \ ]

let s:menus.gina = {
    \ 'description': 'Gina Command'
    \ }
let s:menus.gina.command_candidates = [
    \ ['Gina : <F5> Status :StatusGit', 'StatusGit'],
    \ ['Gina : Stash List :ListStashGit', 'ListStashGit'],
    \ ['Gina : <F8> All Branch :BranchGitAll', 'BranchGitAll'],
    \ ['Gina : <F6> All Logs :LogGitAll', 'LogGitAll'],
    \ ]

let s:menus.my_command = {
    \ 'description': 'My Vim Command'
    \ }
let s:menus.my_command.command_candidates = [
    \ ['* Remove EndSpace', 'EndSpaceDel'],
    \ ['* Toggle number setting', 'NumberToggleRelative'],
    \ ['* Close inactive baffers', 'CloseInactiveBuffers'],
    \ ['* Mark A,(B,C)', 'MmmA'],
    \ ['* <F2> Refresh vimrc', 'ReloadMYVIMRC'],
    \ ['* <F4> Refresh files', 'RefreshFiles'],
    \ ['* <F9> Move tab left', '<C-u>tabm -1'],
    \ ['* <F10> Move tab right', '<C-u>tabm +1'],
    \ ['* <F11> Right open terminal', 'Terminal'],
    \ ['* <F12> Left open terminal', 'sp<CR>:10wincmd_<CR>:terminal'],
    \ ]

let s:menus.my_terminal_command = {
    \ 'description': 'My Terminal Commands'
    \ }
let s:menus.my_terminal_command.command_candidates = [
    \ ['* Find port prosess [lsof -i :<PORT>]', 'CommandToOpenTerminal lsof -i :'],
    \ ['* Docker prune [docker system prune]', 'CommandToOpenTerminal docker system prune'],
    \ ['* chmod [execute permission]', 'CommandToOpenTerminal chmod u+x '],
    \ ['* Sort File [LANG=C sort <Raw File> > <Sort File>]', 'CommandToOpenTerminal LANG=C sort '],
    \ ['* Outputs the difference in both file [comm -3 <A File> <B File>]', 'CommandToOpenTerminal comm -3 '],
    \ ['* Split big file [split -l 10000 <File>]', 'CommandToOpenTerminal split -l 10000 '],
    \ ]

let s:menus.my_menus = {
    \ 'description': 'Menus'
    \ }
let s:menus.my_menus.command_candidates = [
    \ ['* Gina Commands', 'Denite menu:gina -split=floating'],
    \ ['* Setting Files', 'Denite menu:my_setting_files -default-action=left_tabopen -split=floating'],
    \ ['* My Vim Commands', 'Denite menu:my_command -split=floating'],
    \ ['* My Terminal Commands', 'Denite menu:my_terminal_command -split=floating'],
    \ ['* Plugin Management', 'Denite menu:dein -split=floating'],
    \ ]

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
function! MyDeniteVsplit(context) abort
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
                        \ 'denite_vsplit',
                        \ 'MyDeniteVsplit', {'is_quit' : 'v:true'})

" current list
nnoremap <silent> <Space>u :<C-u>Denite file/rec
                    \ -default-action=left_tabopen
                    \ -start-filter
                    \ -split=floating<CR>
" buffer list
nnoremap <silent> <Space>b :<C-u>Denite buffer
                    \ -default-action=denite_vsplit
                    \ -winwidth=`&columns`
                    \ -start-filter
                    \ -split=floating<CR>
" tab buffer list
nnoremap <silent> <Space>t :CloseInactiveBuffers<CR>:<C-u>Denite buffer
                    \ -default-action=denite_vsplit
                    \ -winwidth=`&columns`
                    \ -start-filter
                    \ -split=floating<CR>
" nvim cofig list
nnoremap <silent> <Space>v :<C-u>Denite file/rec:~/dotfiles
                    \ -default-action=left_tabopen
                    \ -start-filter
                    \ -split=floating<CR>
" mark list
nnoremap <silent> <Space>m :<C-u>Denite mymarks:upper
                    \ -default-action=left_tabopen
                    \ -split=floating<CR>
" my menu
nnoremap <silent> <Space>c :<C-u>Denite menu:my_menus
                    \ -split=floating<CR>
" grep
nnoremap <silent> <Space>g :<C-u>Denite grep
                    \ -buffer-name=grep-buffer-denite
                    \ -winwidth=`&columns` -winheight=`&lines`
                    \ -default-action=left_tabopen
                    \ -split=floating<CR>
" visual grep
vnoremap <silent> <Space>g :<C-u>DeniteCursorWord grep
                    \ -buffer-name=grep-buffer-denite
                    \ -winwidth=`&columns` -winheight=`&lines`
                    \ -split=floating<CR>
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
