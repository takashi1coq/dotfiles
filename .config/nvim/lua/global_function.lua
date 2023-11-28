-- var dump
function _G.Dd(...)
  local objects = {}
  for i = 1, select('#', ...) do
    local v = select(i, ...)
    table.insert(objects, vim.inspect(v))
  end
  print(table.concat(objects, '\n'))
  return ...
end

-- explode
function _G.Explode(inputstr, sep)
  if sep == nil then
    sep = "%s"
  end
  local t={}
  for str in string.gmatch(inputstr, "([^"..sep.."]+)") do
    table.insert(t, str)
  end
  return t
end

-- implode
function _G.Implode(t, sep)
  return table.concat(t, sep)
end

-- is empty
function _G.IsEmpty(s)
  return s == nil or s == ''
end
function _G.IsEmptyTable(t)
  return next(t) == nil
end

-- map
-- TODO table.map = function () ...
function _G.Map(value, fn)
  local result = {}
  for i = 1, #value do
    table.insert(result, fn(value[i]))
  end
  return result
end

-- foreach
function _G.Foreach(fn, value)
  for i = 1, #value do
    fn(value[i])
  end
end

-- replace
function _G.Replace(str, what, with)
    what = string.gsub(what, "[%(%)%.%+%-%*%?%[%]%^%$%%]", "%%%1")
    with = string.gsub(with, "[%%]", "%%%%")
    return string.gsub(str, what, with)
end

-- locate
function _G.Rocate(table, value)
  for i = 1, #table do
    if table[i] == value then return true end
  end
  return false
end

-- store yank
function _G.StoreYank(w)
  vim.fn.setreg('+', w)
  vim.fn.setreg('"', w)
  print('yank word => [ '..w..' ]')
end

-- open floating window
function _G.OpenFloatingWindow()
  local buf = vim.api.nvim_create_buf(false, true)
  local option = {
    relative = 'editor'
    , anchor = 'NW'
    , external = false
    , width = math.ceil(vim.o.columns / 2)
    , height = math.ceil(vim.o.lines / 2)
    , col = math.ceil((vim.o.columns / 2) - (vim.o.columns / 4))
    , row = math.ceil((vim.o.lines / 2) - (vim.o.lines / 4))
  }
  vim.api.nvim_open_win(buf, true, option)
  return buf
end

-- get visual
function _G.GetVisual()
  local result = ''
  local mode = vim.fn.mode()
  if mode == 'v' or mode == 'V' then
    local memo = vim.fn.getreginfo('z')
    vim.cmd('noautocmd normal! "zygv')
    local reginfo = vim.fn.getreginfo('z')
    vim.fn.setreg('z', memo)
    result = table.concat(reginfo.regcontents)
  end
  return result
end

-- set visual
function _G.SetVisual(word)
  local mode = vim.fn.mode()
  if mode == 'v' or mode == 'V' then
    local memo = vim.fn.getreginfo('z')
    vim.fn.setreg('z', word)
    vim.cmd('noautocmd normal! "zp')
    vim.fn.setreg('z', memo)
  end
end

-- file open
function _G.FileOpen(f)
  vim.cmd('tabe '..vim.fn.expand(f))
end

-- get projectDirName
function _G.ProjectDirName()
  local path = vim.fn.split(vim.fn.getcwd(), '/')
  return path[#path]
end

-- craete file (if exists)
function _G.IfNotExistsFileCreate(name, text)
  if text == nil then text = '' end
  local fr = io.open(name, 'r')
  if fr == nil then
    local fw = io.open(name,"w")
    if fw ~= nil then
      fw:write(text)
      io.close(fw)
    end
  else
    io.close(fr)
  end
end

-- filter
-- TODO table.filter = function () ...
function _G.Filter(fn, tbl)
  local result = {}
  for i in ipairs(tbl) do
    if fn(tbl[i]) then
      table.insert(result, tbl[i])
    end
  end
  return result
end

-- permutation
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
function _G.Perm (a)
  local n = #a
  local co = coroutine.create(function () permgen(a, n) end)
  return function ()   -- iterator
    local _, res = coroutine.resume(co)
    return res
  end
end

-- file type keymap set
function _G.SetFileTypeKeyMap(fileType, autocmdGroup)
  vim.api.nvim_create_augroup(autocmdGroup, {})
  vim.api.nvim_create_autocmd(
    'FileType'
    , {
      group = autocmdGroup
      , pattern = '*'
      , callback = function(args)
        local func = setmetatable(fileType, {
          __index = function()
            return function() end
          end
        })
        func[args.match]()
      end
    }
  )
end

-- buffer keymap
function _G.VimBufferKeymapSet (type, key, fn, option)
  option = option or {}
  option['buffer'] = true
  vim.keymap.set(type, key, fn, option)
end

-- terminal
function _G.MyTerminal(name, openNum, cmd, path)
  local bufOpenCmd = {
    'botright new'
    , '0tabnew'
  }
  local openBufnr = Filter(function (v)
    local _, count = string.gsub(vim.fn.bufname(v), name, "");
    return not(count == 0)
  end, vim.fn.range(1, vim.fn.bufnr("$")))
  if not(IsEmptyTable(openBufnr)) then
    if IsEmpty(vim.fn.input('already exists. open buffer? :')) then
      Foreach(function (v)
        local bufname = vim.fn.bufname(v)
        local num = string.sub(bufname, string.len(bufname))
        vim.cmd(bufOpenCmd[tonumber(num)])
        vim.cmd(v..'b')
      end, openBufnr)
      return
    end
  end
  vim.cmd(bufOpenCmd[openNum])
  vim.fn.termopen(
    '$SHELL;#'..name..openNum
    , {
      on_exit = function ()
        vim.cmd('q')
      end
      , on_stdout = function (id, data, event)
        -- TODO terminal log..?
      end
      , cwd = path
    }
  )
  vim.api.nvim_put({cmd}, 'c', false, true)
end
vim.keymap.set('n', '<Space>j', function () MyTerminal('terminal_'..ProjectDirName(), 1, nil, nil) end)
vim.api.nvim_create_user_command('Terminal', function () MyTerminal('Terminal', 2, nil, nil) end, { nargs = 0 })

-- quit
function _G.MyQuit ()
  local lastWinNr = vim.fn.winnr('$')
  local targetTabNr = vim.fn.tabpagenr()
  local lastTabNr = vim.fn.tabpagenr('$')
  local idDiff = vim.wo.diff
  if lastWinNr == 1 or idDiff then
    vim.cmd('tabclose')
  else
    vim.cmd('q')
  end
  if (lastWinNr == 1 or idDiff) and not(targetTabNr == 1) and not(lastTabNr == 1) and targetTabNr < lastTabNr then
    vim.cmd('tabprev')
  end
end

-- avoid E162. open empty buffer
function _G.EmptyBufferSettingCmd(cmd)
  vim.cmd(cmd)
  vim.cmd('setlocal nobuflisted buftype=nofile bufhidden=wipe noswapfile')
end

-- delete no name buffer
function _G.DeleteNoNameBuffer ()
  local noNameList = Filter(function (v)
    return vim.fn.bufname(v) == ''
  end, vim.fn.range(1, vim.fn.bufnr('$')))
  for i = 1, #noNameList do
    vim.cmd('bdelete '..noNameList[i])
  end
end

-- exec mac chrome open cmd
function _G.OpenBrowser(url, profile)
  if url == nil then
    url = 'chrome://version'
  end
  if profile == nil then
    profile = 'Default'
  end
  local command = '!open -a "Google Chrome" '..url..' --args --profile-directory="'..profile..'"'
  vim.cmd('silent '..command)
end

-- create delimiter file
-- etc) CreateDelimiterFile('/tmp/CreateDelimiterFile.csv', nil, nil, nil)
function _G.CreateDelimiterFile(path, data, count, sep)
  if path == nil then
    path = '/tmp/CreateDelimiterFile.csv'
  end
  if data == nil then
    data = {
      {
        'id'
        , function () return '' end
      }
      , {
        'key'
        , function (i) return string.format("%09d",i) end
      }
    }
  end
  if count == nil then
    count = 10
  end
  if sep == nil then
    sep = ','
  end
  local t = {}
  table.insert(t, Implode(Map(data, function (d)
    return d[1]
  end), sep))
  for i = 1, count do
    table.insert(t, Implode(Map(data, function (d)
      return d[2](i)
    end), sep))
  end
  local f = io.open(path, 'w')
  if f then
    f:write(Implode(t, '\n'))
    f:close()
  end
end

-- json file to table
function _G.JsonToTable(path)
  local content = ''
  local file = io.open(path, 'r')
  if file then
    content = file:read('*a')
    return vim.fn.json_decode(content)
  end
  return {}
end
