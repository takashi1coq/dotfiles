" function loaded check うんcode
if exists("g:loaded_function")
  finish
endif

let g:loaded_function = 1

" ==========================================================
"  CopyPath & CopyFileName
" ==========================================================
function! CopyPath()
  let l:path = expand('%:p')
  let l:path = substitute(l:path, getcwd(), '', 'g')
  let l:path = substitute(l:path, '^/', '', '')
  let @+=l:path
  " copy unnamed register.
  if !has('clipboard')
    let @"=l:path
  endif
  echomsg l:path
endfunction

function! CopyFileName()
  let @+=expand('%:t:r')
  " copy unnamed register.
  if !has('clipboard')
    let @"=expand('%:t:r')
  endif
  echomsg expand('%:t:r')
endfunction

command! -nargs=0 CopyPath     call CopyPath()
command! -nargs=0 CopyFileName call CopyFileName()

" ==========================================================
"  unused space delete
" ==========================================================
command! EndSpaceDel :%s/\s\+$//ge

" ==========================================================
"  open excommond result whth new tabpage
" ==========================================================
command!
      \ -nargs=+
      \ -complete=command
      \ Capture
      \ call s:cmd_capture([<f-args>])

function! C(cmd)
  redir => result
  silent execute a:cmd
  redir END
  return result
endfunction

function! s:cmd_capture(args)
  let l:res = C(join(a:args))
  MyTabNew
  silent put =l:res
  1,2delete _
endfunction

" ==========================================================
"  open floating window, exec command
" ==========================================================
command!
      \ -nargs=?
      \ -complete=command
      \ OpenFloatingWindowExecCommand
      \ call s:open_floating_window_exec_command(<f-args>)

function! s:open_floating_window_exec_command(...)
  call nvim_open_win(0, v:true, {
        \   'width': &columns / 2,
        \   'height': &lines / 2,
        \   'relative': 'editor',
        \   'anchor': 'NW',
        \   'col': (&columns / 2) - (&columns / 4),
        \   'row': (&lines / 2) - (&lines / 4),
        \   'external': v:false,
        \})
  if a:0 >= 1
    execute a:1
  endif
endfunction

" ==========================================================
"  vimrc reload for dein
" ==========================================================
if has('vim_starting')
  command!
        \ -nargs=?
        \ -complete=command
        \ ReloadMYVIMRC
        \ call s:myvimrc_refresh()

  function! s:myvimrc_refresh()
    source $MYVIMRC
    call dein#recache_runtimepath()
  endfunction
endif
"

" ==========================================================
"  create tabline
" ==========================================================
function! s:tabpage_label(n)
  let title = gettabvar(a:n, 'title')
  if title !=# ''
    retrun title
  endif

  " tabpage内のバッファリスト
  let bufnrs = tabpagebuflist(a:n)

  " カレントタブページかどうかでハイライトを切り替える
  let hi = a:n is tabpagenr() ? '%#TabLineSel#' : '%#TabLine#'

  " tabpage内に変更中のバッファがあれば'+'をつける
  let mod = len(filter(copy(bufnrs), 'getbufvar(v:val, "&modified")')) ? '+' : ''
  let sp = mod ==# '' ? '' : ' ' " 隙間開ける

  let curbufnr = bufnrs[tabpagewinnr(a:n) - 1] " tabpagewinnr() は 1 origin
  let filename = fnamemodify(bufname(curbufnr), ':t')

  " カレントの前後でなければファイル名を'-'とする
  "    if (a:n < tabpagenr() - 1 || a:n > tabpagenr() + 1)
  "        let filename = '-'
  "    endif

  " 無題設定
  let filename = filename ==# '' ? 'NO NAME' : fnamemodify(bufname(curbufnr), ':p:h:t'). '/'. filename

  let label = ' '. mod. sp. filename. ' '

  return '%'. a:n. 'X'. hi. label. '%X%#TabLineFill#'

endfunction

function! MakeTabLine()
  let titles = map(range(1, tabpagenr('$')), 's:tabpage_label(v:val)')
  let sep = ' ' "タブ間の区切り
  let tabpages = join(titles, sep). sep. '%#TabLineFill#%T'
  let info = '' " タブ情報
  return tabpages. '%='. info
endfunction

" ==========================================================
"  MyTabNew うんこ
"  0:count
"  1:path
" ==========================================================
command! -nargs=* MyTabNew call s:both_ends_tabnew(<f-args>)

function! s:both_ends_tabnew(...)
  let l:res = []
  if a:0 >= 1
    if filereadable(expand(a:000[0]))
      call add(l:res, '0')
    endif
    for n in a:000
      call add(l:res, n)
    endfor
  else
    call add(l:res, '0')
  endif
  let num = l:res[0]
  unlet l:res[0]
  if len(l:res) != 0
    for path in l:res
      if expand('%:p') !=# ''
        silent execute ':'. l:num. 'tabnew ' .path
      else
        silent execute ':e'.path
      endif
    endfor
  else
    if expand('%:p') !=# ''
      silent execute ':'. l:num. 'tabnew'
    endif
  endif
endfunction

" ==========================================================
"  open terminal whth new tabpage
" ==========================================================
command! -nargs=0 Terminal call s:my_terminal()

function! s:my_terminal()
  MyTabNew $
  terminal
endfunction

" ==========================================================
"  open bottom terminal
" ==========================================================
command!
      \ -nargs=0
      \ TerminalBottom
      \ call s:terminal_bottom()

function! s:terminal_bottom()
  execute 'botright split'
  execute 'terminal'
endfunction

" ==========================================================
"  DiffNewFile
" ==========================================================
command! -nargs=0 DiffNewFile :vertical diffsplit /tmp/mydiff

" ==========================================================
"  replace highlight
" ==========================================================
command! -nargs=1 ReplaceHihl call s:replace_hihl(<f-args>)

function! s:replace_hihl(word)
  silent execute ':%s//'. a:word. '/g'
endfunction

" ==========================================================
"  trans
" ==========================================================
command! -nargs=? JpEnTrans call s:jp_en_trans(<f-args>)

function! MyVisual()
  let [lnum1, col1] = getpos("'<")[1:2]
  let [lnum2, col2] = getpos("'>")[1:2]
  let lines = getline(lnum1, lnum2)
  if lnum1 == 0 && lnum2 == 0 && col1 == 0 && col2 == 0
    return ''
  endif
  let lines[-1] = lines[-1][:col2 - (&selection == 'inclusive' ? 1 : 2)]
  let lines[0] = lines[0][col1 - 1:]
  return join(lines, " ")
endfunction

function! s:jp_en_trans(...)
  let l:str = MyVisual()
  if a:0 >= 1
    let l:str = a:1
  endif
  echomsg system('trans -b -sl=en -tl=ja '. '"'. l:str. '"')
endfunction

" ==========================================================
"  make window one
" ==========================================================
command! -nargs=0 MakeWinOne call s:win_one()

function! s:win_one()
  let winr = win_getid()
  let winr_list = win_findbuf(bufnr('%'))

  for dup_winr in winr_list
    if dup_winr != winr
      call win_gotoid(dup_winr)
      quit
    endif
  endfor
  call win_gotoid(winr)
endfunction

" ==========================================================
"  tab sp
" ==========================================================
command! -nargs=0 TabSplit call s:tab_sp()

function! s:tab_sp()
  execute '0tab split'
  execute 'MakeWinOne'
endfunction

" ==========================================================
"  toggle relativenumber
" ==========================================================
command! -nargs=0 ToggleNumber call s:toggle_relative_number()

function! s:toggle_relative_number()
  execute 'setlocal relativenumber!'
endfunction

" ==========================================================
"  ファイルの存在しないバッファを閉じる
" ==========================================================
command! -bar RefreshFiles call s:refresh_files()

function! s:refresh_files()

  " refresh tabpage
  let save_tab = tabpagenr()
  let save_win = winnr()
  execute 'tabdo e!'
  execute 'tabnext '. save_tab
  execute save_win. ' wincmd w'

  " delete no file buffer
  let list = filter(range(1, bufnr("$")),
        \        'bufexists(bufname(v:val)) && !filereadable(expand("#".v:val.":p")) && buflisted(v:val)'
        \    )
  for v in list
    if getbufvar(v, '&buftype') != 'terminal'
      execute "bd ".v
    endif
  endfor

endfunction

" ==========================================================
"  echo $PATH
" ==========================================================
command! -bar EchoPath call s:echo_path()

function! s:echo_path()
  silent execute 'Capture !echo $PATH'
  silent execute '%s/://g'
endfunction

" ==========================================================
"  my quit
" ==========================================================
command! -bar MyQuit call s:my_quit()

function! s:my_quit()
  let path = expand('%:p')
  if l:path ==# ''
    silent execute 'quit!'
  else
    if &diff
      silent execute 'tabc'
    else
      silent execute 'wincmd c'
    endif
  endif
endfunction

" ==========================================================
"  not active buffer close
" ==========================================================
command! -nargs=0 CloseInactiveBuffers call s:close_inactive_buffers()

function! s:close_inactive_buffers()
  " let buffers = filter(range(1, bufnr('$')), 'bufexists(v:val)')
  let buffers = nvim_list_bufs()
  for bufnr in l:buffers
    if buflisted(l:bufnr) != 0
      if win_findbuf(l:bufnr) == []
        execute 'bd! '. l:bufnr
      endif
    endif
  endfor
endfunction

" ==========================================================
"  command to open terminal
" ==========================================================
command!
      \ -nargs=1
      \ CommandToOpenTerminal
      \ call s:command_to_open_terminal(<f-args>)

function! s:command_to_open_terminal(arge)
  Terminal
  silent put =a:arge
endfunction

" ==========================================================
"  insert gist row
" ==========================================================
command!
      \ -nargs=1
      \ InsertGistRow
      \ call s:insert_gist_row(<f-args>)

function! s:insert_gist_row(arge)
  r!curl -OLsS a:arge
endfunction

" ==========================================================
"  mark
" ==========================================================
command!
      \ -nargs=1
      \ MarkFile
      \ call s:my_mark_function(<f-args>)

function! s:my_mark_function(arge)
  execute 'mark '. a:arge
  echomsg 'mark '. a:arge
endfunction

nnoremap <silent> mm :MarkFile A<CR>

" ==========================================================
"  indent
" ==========================================================
command! -nargs=0 Indent :execute 'normal gg=G'

" ==========================================================
"  mark A open
" ==========================================================
command! -nargs=0 OpenMarkA :execute 'normal `A'

" ==========================================================
"  sed -i .env
" ==========================================================
command!
      \ -nargs=*
      \ SedIEnv
      \ call s:sed_i_file(<f-args>)

function! s:sed_i_file(...)
  let l:name = a:1
  let l:val = a:2
  let l:file = a:3
  let command = "sed -i "."'s/". l:name. "=.*/". l:name. "=". l:val. "/g' ". l:file
  let @+=l:command
  if !has('clipboard')
    let @"=l:command
  endif
  echomsg l:command
endfunction

" ==========================================================
"  open anything
" ==========================================================
command! -nargs=0 OpenFileBrowser :silent execute '!open %'
command! -nargs=0 OpenDirExplorer :silent execute '!open %:h'

" ==========================================================
"  tab size
" ==========================================================
command! -nargs=0 SetTabSize2 :silent execute 'set tabstop=2 softtabstop=2 shiftwidth=2'
command! -nargs=0 SetTabSize4 :silent execute 'set tabstop=4 softtabstop=4 shiftwidth=4'
