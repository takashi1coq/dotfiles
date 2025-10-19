
return {
  find = function (list, target)
    for i = 1, #list do
      if list[i] == target then return true end
    end
    return false
  end
  , table_to_string = function (list, separator)
    return table.concat(list, separator)
  end
  , string_to_table = function (text, separator)
    if separator == nil then
     separator = "%s"
    end
    local result={}
    for row in string.gmatch(text, "([^"..separator.."]+)") do
      table.insert(result, row)
    end
    return result
  end
  , transform = function (callback, list)
    local result = {}
    for key, value in ipairs(list) do
      local callback_result = callback(key, value)
      if callback_result ~= nil then
        table.insert(result, callback_result)
      end
    end
    return result
  end
  , is_empty = function (list)
    return next(list) == nil
  end
  , inspect_and_join = function (...)
    local objects = {}
    for i = 1, select('#', ...) do
      local v = select(i, ...)
      table.insert(objects, vim.inspect(v))
    end
    return objects
  end
}
