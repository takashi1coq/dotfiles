" ==========================================================
"  main settings
" ==========================================================
set diffopt+=vertical
let g:mapleader = ','

" ==========================================================
"  function
" ==========================================================
" make current path
function! s:get_current_relpath() abort
    let git = gina#core#get_or_fail()
    let abspath = gina#core#repo#abspath(git, '')
    let curpath = substitute(expand('%:p'), '\', '/', 'g')
    let relpath = substitute(curpath, abspath, '', '')
    return relpath
endfunction

" ==========================================================
"  Status
" ==========================================================
call gina#custom#command#option('status', '-s')
call gina#custom#command#option('status', '-b')
command! -nargs=0 StatusGit :execute 'Gina status'
nnoremap <silent> <F5> :StatusGit<CR>

" ==========================================================
"  Commit
" ==========================================================
call gina#custom#command#option('commit', '--opener', 'vsplit')
command! -nargs=0 CommitGit :execute 'Gina commit'

" ==========================================================
"  Branch
" ==========================================================
call gina#custom#command#option('branch', '--opener', 'split')
" new branch
call gina#custom#mapping#nmap('branch', 'nn',
            \ ':call gina#action#call("branch:new")<CR>',
            \ {'noremap':1, 'silent': 1})
" fetch
call gina#custom#mapping#nmap('branch', 'fe',
            \ ':call gina#action#call("branch:refresh")<CR>',
            \ {'noremap':1, 'silent': 1})
" chenge
call gina#custom#mapping#nmap('branch', 'ch',
            \ ':call gina#action#call("changes:of:vsplit")<CR>',
            \ {'noremap':1, 'silent': 1})
" marge
call gina#custom#mapping#nmap('branch', 'ma',
            \ ':call gina#action#call("commit:merge:no-ff")<CR>',
            \ {'noremap':1, 'silent': 1})
" delete
call gina#custom#mapping#nmap('branch', 'dd',
            \ ':call gina#action#call("branch:delete")<CR>',
            \ {'noremap':1, 'silent': 1})
command! -nargs=0 BranchGit :execute 'Gina branch'
nnoremap <silent> <F7> :BranchGit<CR>
command! -nargs=0 BranchGitAll :execute 'Gina branch --all'
nnoremap <silent> <F8> :BranchGitAll<CR>

" ==========================================================
"  Log
" ==========================================================
call gina#custom#command#option('log', '--graph')
call gina#custom#command#option('log', '--decorate=full')
" chenge
call gina#custom#mapping#nmap('log', 'ch',
            \ ':call gina#action#call("changes:of:split")<CR>',
            \ {'noremap':1, 'silent': 1})
" reset HEAD
call gina#custom#mapping#nmap('log', 'rr',
            \ ':call gina#action#call("commit:reset")<CR>',
            \ {'noremap':1, 'silent': 1})
command! -nargs=0 LogGit :execute 'Gina log --opener=tabedit --branches --tags --remotes'
nnoremap <silent> <F6> :LogGit<CR>
command! -nargs=0 LogCurrentGit :execute 'Gina log :' . <SID>get_current_relpath()

" ==========================================================
"  Patch
" ==========================================================
command! -nargs=0 PatchGit :execute 'Gina patch'

" ==========================================================
"  Stash
" ==========================================================
command! -nargs=0 SaveStashGit :execute 'Gina stash save -u "gina stash"'
command! -nargs=0 PopStashGit :execute 'Gina stash pop'
command! -nargs=0 ListStashGit :execute 'Gina stash list --opener=vsplit'
