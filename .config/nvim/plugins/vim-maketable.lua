local fileType = {}
fileType['markdown'] = function ()
  vim.fn.bufferKeymapSet('v', 't', [[<Cmd>'<,'>MakeTable!<CR>]])
  vim.fn.bufferKeymapSet('n', 'c', [[<Cmd>UnmakeTable<CR>]])
end
vim.fn.createFileTypeAugroup(fileType, 'vim_maketable')
