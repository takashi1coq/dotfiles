" ==========================================================
" lsp setting
" ==========================================================
let g:LanguageClient_serverCommands = {}
" python
if executable('pyls')
    let g:LanguageClient_serverCommands['python'] = ['pyls']
endif

" ==========================================================
" mapping
" ==========================================================
function! LC_maps()
  if has_key(g:LanguageClient_serverCommands, &filetype)
    nnoremap <buffer> <silent> K :call LanguageClient#textDocument_hover()<CR>
    nnoremap <buffer> <silent> gd :call LanguageClient#textDocument_definition()<CR>
    nnoremap <buffer> <silent> rr :call LanguageClient#textDocument_rename()<CR>
  endif
endfunction

autocmd MyAutoCmd FileType * call LC_maps()
