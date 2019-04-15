" main settings
set diffopt+=vertical
let g:mapleader = ','

" make current path
function! s:get_current_relpath() abort
    let git = gina#core#get_or_fail()
    let abspath = gina#core#repo#abspath(git, '')
    let curpath = substitute(expand('%:p'), '\', '/', 'g')
    let relpath = substitute(curpath, abspath, '', '')
    return relpath
endfunction

" status
call gina#custom#command#option('status', '-s')
call gina#custom#command#option('status', '-b')
command! -nargs=0 StatusGit :execute 'Gina status'

" commit
call gina#custom#command#option('commit', '--opener', 'vsplit')
command! -nargs=0 CommitGit :execute 'Gina commit'

" branch
call gina#custom#command#option('branch', '--opener', 'split')
call gina#custom#command#option('branch', '--all')
command! -nargs=0 BranchGit :execute 'Gina branch'

" log
call gina#custom#command#option('log', '--graph')
call gina#custom#command#option('log', '--decorate=full')
call gina#custom#mapping#nmap('log', 'ch',
            \ ':call gina#action#call("changes:of:split")<CR>',
            \ {'noremap':1, 'silent': 1})
call gina#custom#mapping#nmap('log', 'rr',
            \ ':call gina#action#call("commit:reset")<CR>',
            \ {'noremap':1, 'silent': 1})
command! -nargs=0 LogGit :execute 'Gina log --opener=tabedit'
command! -nargs=0 LogCurrentGit :execute 'Gina log :' . <SID>get_current_relpath()

" patch?
command! -nargs=0 PatchGit :execute 'Gina patch'

" stash
command! -nargs=0 SaveStashGit :execute 'Gina stash save -u "gina stash"'
command! -nargs=0 PopStashGit :execute 'Gina stash pop'
command! -nargs=0 ListStashGit :execute 'Gina stash list --opener=vsplit'
