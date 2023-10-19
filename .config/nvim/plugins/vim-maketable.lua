local fileType = {}
fileType['markdown'] = function ()
  VimBufferKeymapSet('v', 't', [[<Cmd>'<,'>MakeTable!<CR>]])
  VimBufferKeymapSet('n', 'c', [[<Cmd>UnmakeTable<CR>]])
end
SetFileTypeKeyMap(fileType, 'vim_maketable')
