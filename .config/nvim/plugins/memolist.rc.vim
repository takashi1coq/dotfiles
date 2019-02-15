" path
let g:memolist_path = "~/work/memo/docs"

" date format (default %Y-%m-%d %H:%M)
let g:memolist_memo_date = "%Y-%m-%d"

" tags prompt (default 0)
"let g:memolist_prompt_tags = 1

" categories prompt (default 0)
"let g:memolist_prompt_categories = 1

" use denite (default 0)
let g:memolist_denite = 1

" use arbitrary denite source (default is 'file_rec')
let g:memolist_denite_source = "file_rec"

" use arbitrary denite option (default is empty)
let g:memolist_denite_option = "buffer -default-action=tabopen"

" mappings
nnoremap <silent>mn :<C-u>MemoNew<CR>
nnoremap <silent>ml :<C-u>MemoList<CR>
nnoremap <silent>mg :<C-u>MemoGrep<CR>
