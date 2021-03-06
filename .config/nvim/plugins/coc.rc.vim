set hidden
" You will have bad experience for diagnostic messages when it's default 4000.
set updatetime=300

let g:coc_global_extensions = [
      \ 'coc-python', 'coc-snippets', 'coc-docker', 'coc-solargraph',
      \ 'coc-tsserver', 'coc-word', 'https://github.com/andys8/vscode-jest-snippets']

" to disable auto preview of location list
let g:coc_enable_locationlist = 0
" custom auto preview of location list
augroup Vimrc_coc
  autocmd!
  autocmd User CocLocationsChange CocList --top --normal location
augroup END

let g:coc_snippet_next = '<C-k>'
let g:coc_snippet_prev = '<C-j>'

" use <tab> for trigger completion and navigate to the next complete item
function! s:check_back_space() abort
  let col = col('.') - 2
  return !col || getline('.')[col - 1]  =~ '\s'
endfunction

inoremap <silent><expr> <Tab>
      \ pumvisible() ? "\<C-n>" :
      \ <SID>check_back_space() ? "\<Tab>" :
      \ coc#refresh()

inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"

" rename
nmap <silent> rr <Plug>(coc-rename)
" 呼び出し先
nmap <silent> gr <Plug>(coc-references)
" 定義
nmap <silent> <C-k> <Plug>(coc-definition)
" クラスの実装およびメソッドの実装
nmap <silent> gh <Plug>(coc-implementation)

" ドキュメント
nnoremap <silent> gd :call <SID>show_documentation()<CR>
function! s:show_documentation()
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  else
    call CocAction('doHover')
  endif
endfunction

nmap <silent> [g <Plug>(coc-diagnostic-prev)
nmap <silent> ]g <Plug>(coc-diagnostic-next)

nmap <silent> ff <Plug>(coc-format)

au MyAutoCmd ColorScheme * highlight CocErrorHighlight ctermbg=52 ctermfg=226
au MyAutoCmd ColorScheme * highlight CocWarningHighlight ctermbg=19 ctermfg=226
au MyAutoCmd ColorScheme * highlight CocInfoHighlight ctermbg=19 ctermfg=226
