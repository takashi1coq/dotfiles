-- os..
os.yyyy = function () return os.date('%Y') end
os.mm = function () return os.date('%m') end
os.dd = function () return os.date('%d') end
os.yyyymmdd = function () return os.date('%Y%m%d') end
os.hhmmss = function () return os.date('H%M%S') end
os.yyyymmddhhmmss = function () return os.date('%Y%m%d%H%M%S') end
os.all = function () return os.date('%c') end
os.formatdate = function () return os.date('%x') end
os.formathhmmss = function () return os.date('%X') end
os.dump = function (...)
  local objects = {}
  for i = 1, select('#', ...) do
    local v = select(i, ...)
    table.insert(objects, vim.inspect(v))
  end
  print(table.concat(objects, '\n'))
  return ...
end
-- os.permutation
local function permgen (a, n)
  if n == 0 then
    coroutine.yield(a)
  else
    for i=1,n do
      -- put i-th element as the last one
      a[n], a[i] = a[i], a[n]
      -- generate all permutations of the other elements
      permgen(a, n - 1)
      -- restore i-th element
      a[n], a[i] = a[i], a[n]
    end
  end
end
os.permutation = function (t)
  local n = #t
  local co = coroutine.create(function () permgen(t, n) end)
  return function ()   -- iterator
    local _, res = coroutine.resume(co)
    return res
  end
end

-- table..
table.explode = function (s, sep)
  if sep == nil then
    sep = "%s"
  end
  local t={}
  for str in string.gmatch(s, "([^"..sep.."]+)") do
    table.insert(t, str)
  end
  return t
end
table.isEmpty = function (t)
  return next(t) == nil
end
table.map = function (t, fn)
  local result = {}
  for i = 1, #t do
    table.insert(result, fn(t[i]))
  end
  return result
end
table.myForeach = function (fn, t)
  for i = 1, #t do
    fn(t[i])
  end
end
table.locate = function (t, s)
  for i = 1, #t do
    if t[i] == s then return true end
  end
  return false
end
table.commandResultAsTable = function (cmd)
  local result = {}
  local handle, err = io.popen(cmd)
  if (handle) then
    result = table.explode(handle:read("*a"))
    handle:close()
  else
    os.dump('table.commandResultAsTable error code : '..err)
  end
  return result
end
table.filter = function (fn, t)
  local result = {}
  for i in ipairs(t) do
    if fn(t[i]) then
      table.insert(result, t[i])
    end
  end
  return result
end
table.jsonDecode = function (path)
  local content = ''
  local file = io.open(path, 'r')
  if file then
    content = file:read('*a')
    return vim.fn.json_decode(content)
  end
  return {}
end

-- string..
string.implode = function (t, sep)
  return table.concat(t, sep)
end
string.isEmpty = function (s)
  return s == nil or s == ''
end
string.patternEscape = function (pattern)
  return string.gsub(pattern, "[%(%)%.%+%-%*%?%[%]%^%$%%]", "%%%1")
end
string.myFind = function (s, pattern)
  return string.find(s, string.patternEscape(pattern))
end
string.replace = function (str, what, with)
    what = string.gsub(what, "[%(%)%.%+%-%*%?%[%]%^%$%%]", "%%%1")
    with = string.gsub(with, "[%%]", "%%%%")
    return string.gsub(str, what, with)
end
string.getExtension = function (path)
  local explodePath = table.explode(path, '.')
  return explodePath[#explodePath]
end
