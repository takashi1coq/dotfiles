" ==========================================================
" lsp setting
" ==========================================================
let g:LanguageClient_serverCommands = {}
" python
if executable('pyls')
    let g:LanguageClient_serverCommands['python'] = ['pyls']
endif
" javascript / npm i -g javascript-typescript-langserver
if executable('javascript-typescript-stdio')
    let g:LanguageClient_serverCommands['javascript'] = ['javascript-typescript-stdio']
    let g:LanguageClient_serverCommands['javascript.jsx'] = ['javascript-typescript-stdio']
    let g:LanguageClient_serverCommands['typescript'] = ['javascript-typescript-stdio']
endif

" ==========================================================
" mapping
" ==========================================================
function! LC_maps()
  if has_key(g:LanguageClient_serverCommands, &filetype)
    nnoremap <buffer> <silent> K :call LanguageClient#textDocument_hover()<CR>
    nnoremap <buffer> <silent> D :call LanguageClient#textDocument_definition()<CR>
    nnoremap <buffer> <silent> R :call LanguageClient#textDocument_rename()<CR>
  endif
endfunction

autocmd MyAutoCmd FileType * call LC_maps()
