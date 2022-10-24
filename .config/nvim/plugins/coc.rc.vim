set hidden
" You will have bad experience for diagnostic messages when it's default 4000.
set updatetime=300

let g:coc_global_extensions = [
      \ 'coc-snippets', 'coc-word'
      \ , 'coc-docker'
      \ , 'coc-python'
      \ , 'coc-solargraph'
      \ , 'coc-tsserver', 'https://github.com/andys8/vscode-jest-snippets'
      \ , 'coc-phpls'
      \ ]

" to disable auto preview of location list
let g:coc_enable_locationlist = 0
" custom auto preview of location list
augroup Vimrc_coc
  autocmd!
  autocmd User CocLocationsChange CocList --top --normal location
augroup END

" Use tab for trigger completion with characters ahead and navigate.
" NOTE: There's always complete item selected by default, you may want to enable
" no select by `"suggest.noselect": true` in your configuration file.
" NOTE: Use command ':verbose imap <tab>' to make sure tab is not mapped by
" other plugin before putting this into your config.
inoremap <silent><expr> <TAB>
      \ coc#pum#visible() ? coc#pum#next(1) :
      \ CheckBackspace() ? "\<Tab>" :
      \ coc#refresh()
inoremap <expr><S-TAB> coc#pum#visible() ? coc#pum#prev(1) : "\<C-h>"

" Make <CR> to accept selected completion item or notify coc.nvim to format
" <C-g>u breaks current undo, please make your own choice.
inoremap <silent><expr> <CR> coc#pum#visible() ? coc#pum#confirm()
                              \: "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"

function! CheckBackspace() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

" Use <c-space> to trigger completion.
inoremap <silent><expr> <c-space> coc#refresh()

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
