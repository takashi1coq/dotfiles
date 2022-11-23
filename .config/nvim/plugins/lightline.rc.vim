let g:lightline = {
      \ 'colorscheme': 'molokai',
      \ 'active': {
      \   'left': [ [ 'mode', 'paste' ],
      \             [ 'readonly', 'rootPath', 'branchName', 'modified' ] ]
      \ },
      \ 'component_function': {
      \   'rootPath': 'GetMyCwd',
      \   'branchName': 'BranchName',
      \ },
      \ }

function! GetMyCwd()
  return getcwd()
endfunction

function! BranchName()
  return gina#component#repo#branch()
endfunction
