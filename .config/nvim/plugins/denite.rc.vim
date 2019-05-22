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
        \ '.git/', 'build/', '__pycache__/', 'node_modules/',
        \ 'images/', 'img/',
        \ '*.o', '*.make', '.myroot' ])

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
