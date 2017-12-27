"kopipe. use ag
if executable('ag')
    call denite#custom#var('file_rec', 'command', ['ag', '--follow', '--nocolor', '--nogroup', '-g', ''])
    call denite#custom#var('grep', 'command', ['ag'])
    call denite#custom#var('grep', 'recursive_opts', [])
    call denite#custom#var('grep', 'pattern_opt', [])
    call denite#custom#var('grep', 'default_opts', ['--follow', '--no-group', '--no-color'])
endif

" 選択をvimマッピング
call denite#custom#map('insert', '<C-j>','<denite:move_to_next_line>', 'noremap')
call denite#custom#map('insert', '<C-k>','<denite:move_to_previous_line>', 'noremap')

" customize ignore globs
call denite#custom#source('file_rec','matchers',['matcher_fuzzy','matcher_ignore_globs'])
call denite#custom#filter('matcher_ignore_globs','ignore_globs',
        \ [
        \ '.git/', 'build/', '__pycache__/', 'node_modules/',
        \ 'images/', 'img/',
        \ '*.o', '*.make' ])
