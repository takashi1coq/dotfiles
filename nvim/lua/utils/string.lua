
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

}
