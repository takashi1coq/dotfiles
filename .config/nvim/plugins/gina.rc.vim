set diffopt+=vertical

let g:mapleader = ','

" status
call gina#custom#command#option('status', '-s')
call gina#custom#command#option('status', '-b')
nnoremap <silent> <Leader>gs :<C-u>Gina status<CR>

" commit
nnoremap <silent> <Leader>gc :<C-u>Gina commit --opener=vsplit<CR>

" branch
nnoremap <silent> <Leader>gb :<C-u>Gina branch --opener=split --all<CR>

" log
call gina#custom#command#option('log', '--graph')
call gina#custom#command#option('log', '--decorate=full')
nnoremap <silent> <Leader>gl :<C-u>Gina log --opener=tabedit<CR>

" path?
nnoremap <silent> <Leader>gp :<C-u>Gina patch<CR>

" stash
nnoremap <silent> <Leader>ss :<C-u>Gina stash save -u<CR>
nnoremap <silent> <Leader>sp :<C-u>Gina stash pop<CR>
nnoremap <silent> <Leader>sl :<C-u>Gina stash list --opener=vsplit<CR>
