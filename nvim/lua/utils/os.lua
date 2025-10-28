
return {
  execute_command_to_table = function (cmd)
    local result = {}
    local handle, err = io.popen(cmd)
    if (handle) then
      result = _G.TKC.utils.table.string_to_table(handle:read("*a"), '%s')
      handle:close()
    else
      _G.TKC.utils.message.error('utils.os.execute_command_to_table error : '..err)
    end
    return result
  end
  , dump = function(...)
    print(_G.TKC.utils.string.inspect_and_join(...))
  end
  , open_explorer = function (path)
    local cmd = ''
    if vim.fn.has('mac') == 1 then
      cmd = 'open '..path
    elseif vim.fn.has('win32') == 1 then
      cmd = 'start '..path
    else
      _G.TKC.utils.message.error('utils.os.open_explorer faild')
      return
    end
    vim.fn.jobstart(cmd , { detach = true })
  end
  , open_browser = function (url)
    local cmd = ''
    if vim.fn.has('mac') == 1 then
      cmd = 'open '..url
    elseif vim.fn.has('win32') == 1 then
      cmd = 'start '..url
    else
      _G.TKC.utils.message.error('utils.os.open_browser faild')
      return
    end
    vim.fn.jobstart(cmd , { detach = true })
  end
}
