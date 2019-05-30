" ==========================================================
" LanguageClient setting
" ==========================================================
"let g:LanguageClient_hasSnippetSupport = 0
"let g:LanguageClient_useFloatingHover = 1
"let g:LanguageClient_settingsPath = expand('~/.config/nvim/plugins/LanguageClient-neovim.setting.json')

" ==========================================================
" filetype setting
" ==========================================================
let g:LanguageClient_serverCommands = {}

" python
if executable('pyls')
    let g:LanguageClient_serverCommands['python'] = ['pyls']
endif

" javascript
if executable('javascript-typescript-stdio')
    let g:LanguageClient_serverCommands['javascript'] = ['javascript-typescript-stdio']
    let g:LanguageClient_serverCommands['javascript.jsx'] = ['javascript-typescript-stdio']
    let g:LanguageClient_serverCommands['typescript'] = ['javascript-typescript-stdio']
endif

"  html
if executable('html-languageserver')
    let g:LanguageClient_serverCommands['html'] = ['html-languageserver', '--stdio']
endif

" ==========================================================
" mapping
" ==========================================================
function! LC_maps()
    if has_key(g:LanguageClient_serverCommands, &filetype)
        " jump
        nnoremap <buffer> <silent> <C-k> :call LanguageClient#textDocument_definition()<CR>
        " open document
        nnoremap <buffer> <silent> K :call LanguageClient#textDocument_hover()<CR>
        " rename
        nnoremap <buffer> <silent> R :call LanguageClient#textDocument_rename()<CR>
        " document highlight
        nnoremap <buffer> <silent> H :call LanguageClient_textDocument_documentHighlight()<CR>
        nnoremap <buffer> <silent> cH :call LanguageClient#clearDocumentHighlight()<CR>
    endif
endfunction

autocmd MyAutoCmd FileType * call LC_maps()
