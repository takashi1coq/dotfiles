
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
}
