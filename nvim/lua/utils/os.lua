
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
  , inspect_and_join = function (...)
    local objects = {}
    for i = 1, select('#', ...) do
      local v = select(i, ...)
      table.insert(objects, vim.inspect(v))
    end
    return _G.TKC.utils.table.table_to_string(objects, '\n')
  end
  , dump = function(...)
    print(_G.TKC.utils.os.inspect_and_join(...))
  end
}
