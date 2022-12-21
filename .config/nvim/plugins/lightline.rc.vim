let g:lightline = {
      \ 'colorscheme': 'molokai',
      \ 'active': {
      \   'left': [ [ 'mode', 'paste' ],
      \             [ 'readonly', 'projectName', 'fileFullName', 'branchName', 'modified' ] ]
      \ },
      \ 'component_function': {
      \   'projectName': 'LightLineGetProject',
      \   'branchName': 'LightLineBranchName',
      \   'fileFullName': 'LightLineFileFullName',
      \ },
      \ 'tab_component_function': {
      \   'filename': 'LightLineTabName',
      \ },
      \ }

function! LightLineGetProject()
  let l:projectDir = split(getcwd(), '/')
  return l:projectDir[-1]
endfunction

function! LightLineFileFullName()
  let l:fullName = expand('%:p')
  let l:fullName = substitute(l:fullName, getcwd(), '', 'g')
  let l:fullName = substitute(l:fullName, '^/', '', '')
  return l:fullName !=# '' ? l:fullName : '[No Name]'
endfunction

function! LightLineBranchName()
  return gina#component#repo#branch()
endfunction

function! LightLineTabName(n)
  let l:bufnr = tabpagebuflist(a:n)[tabpagewinnr(a:n) - 1]
  let l:dir = expand('#' . l:bufnr . ':p:h:t')
  let l:file = expand('#' . l:bufnr . ':t')
  let l:tabname = '' != l:file ? l:dir. '/'. l:file : '[No Name]'
  return l:tabname
endfunction
