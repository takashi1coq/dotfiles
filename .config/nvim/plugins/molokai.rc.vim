" Comment
au MyAutoCmd ColorScheme * highlight Comment ctermfg=63
" CursorLine
au MyAutoCmd ColorScheme * highlight CursorLine ctermbg=236
" Search
au MyAutoCmd ColorScheme * highlight Search ctermbg=55 ctermfg=226
" Visual
au MyAutoCmd ColorScheme * highlight Visual ctermbg=239
" TabLine
au MyAutoCmd ColorScheme * highlight TabLine ctermbg=None ctermfg=15
" TabLineSel
au MyAutoCmd ColorScheme * highlight TabLineSel ctermbg=255 ctermfg=0
" TabLineFill
au MyAutoCmd ColorScheme * highlight TabLineFill cterm=bold ctermbg=240 ctermfg=49
" StatusLine
au MyAutoCmd ColorScheme * highlight StatusLine ctermbg=226
" SpellLocal
au MyAutoCmd ColorScheme * highlight SpellLocal ctermbg=24 gui=undercurl guisp=#7070F0

au MyAutoCmd VimEnter * nested colorscheme molokai
