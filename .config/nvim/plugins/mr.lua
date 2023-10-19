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
    local count = 5
    local except = {
      'markdown'
      , 'lua'
    }
    for i in ipairs(list) do
      if vim.fn.getftype(list[i]) then
        if Rocate(except, vim.filetype.match({filename = list[i]})) then
          count = count + 1
        else
          if i <= count then
            table.insert(files, list[i])
          end
        end
      end
    end
    files = Reverse(files);
    for i in ipairs(files) do
      vim.cmd('tabe '..files[i])
    end
    DeleteNoNameBuffer()
  end
  , { nargs = 0 }
)
function _G.Reverse(t)
  local result = {}
  for i=#t, 1, -1 do
    result[#result+1] = t[i]
  end
  return result
end
