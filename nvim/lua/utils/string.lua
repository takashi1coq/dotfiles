
return {
  replace = function (text, what, with)
    what = string.gsub(what, "[%(%)%.%+%-%*%?%[%]%^%$%%]", "%%%1")
    with = string.gsub(with, "[%%]", "%%%%")
    return string.gsub(text, what, with)
  end
  , remove_first_n_chars = function (text, num)
    return string.sub(text, num + 1)
  end
  , is_empty = function (text)
    return text == nil or text == ''
  end
  , inspect_and_join = function (...)
    local objects = {}
    for i = 1, select('#', ...) do
      local v = select(i, ...)
      table.insert(objects, vim.inspect(v))
    end
    return _G.TKC.utils.table.table_to_string(objects, '\n')
  end
}
