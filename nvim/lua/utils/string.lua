
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
    return _G.TKC.utils.table.table_to_string(
      _G.TKC.utils.table.inspect_and_join(...)
      , '\n'
    )
  end
  , random = function (length)
    local chars = {
      '0','1','2','3','4','5','6','7','8','9'
      , 'a','b','c','d','e','f','g','h','i','j','k','l','m','n'
      , 'o','p','q','r','s','t','u','v','w','x','y','z'
      , 'A','B','C','D','E','F','G','H','I','J','K','L','M','N'
      , 'O','P','Q','R','S','T','U','V','W','X','Y','Z'
    }
    local result = {}
    for i = 1, length do
      result[i] = chars[math.random(1, #chars)]
    end
    return _G.TKC.utils.table.table_to_string(result)
  end
  , separator = ' : '
  , camel_to_snake_case = function (str)
    return str
      :gsub('(%l)(%u)', '%1_%2')
      :gsub('(%l)(%u%l)', '%1_%2')
      :lower()
  end
  , snake_to_camel_case = function (str)
    return str
      :gsub('_%a', function(s)
        return s:sub(2):upper()
      end)
  end
}
