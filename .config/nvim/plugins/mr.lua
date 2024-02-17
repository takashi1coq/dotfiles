vim.g['mr#threshold'] = 50
vim.g['mr#mrw#predicates'] = {
  function(filename)
    return vim.regex([[COMMIT_EDITMSG]]):match_str(filename) == nil
  end
}
vim.api.nvim_create_user_command(
  'OpenMrwFile'
  , function ()
    local list = vim.fn['mr#mrw#list']()
    local files = {}
    local count = 1
    local exceptFiletype = {
      'markdown'
      , 'csv'
      , 'json'
    }
    local exceptExtension = {
      'log'
    }
    for i = 1, #list do
      local filePath = list[i]
      local extension = string.getExtension(filePath)
      local isFileType = table.locate(exceptFiletype, vim.filetype.match({filename = filePath}))
      local isExtension = table.locate(exceptExtension, extension)
      if vim.fn.getftype(filePath) then
        if isFileType or isExtension then
          count = count + 1
        else
          if i <= count then
            table.insert(files, filePath)
          end
        end
      end
    end
    files = table.reverse(files);
    for i = 1, #files do
      if i == 1 then
        vim.cmd('e '..files[i])
      else
        vim.cmd('tabe '..files[i])
      end
    end
  end
  , { nargs = 0 }
)
