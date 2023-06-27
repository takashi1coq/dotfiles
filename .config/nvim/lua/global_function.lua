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

-- is empty
function _G.IsEmpty(s)
  return s == nil or s == ''
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

-- file open
function _G.FileOpen(f)
  vim.cmd('tabe '..vim.fn.expand(f))
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
function _G.MyTerminal(cmdNum, cmd, path)
  local bufOpenCmd = {
    'botright new'
    , '0tabnew'
  }
  vim.cmd(bufOpenCmd[cmdNum])
  vim.fn.termopen(
    '$SHELL'
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
vim.keymap.set('n', '<Space>j', function () MyTerminal(1, nil, nil) end)
vim.api.nvim_create_user_command('Terminal', function () MyTerminal(2, nil, nil) end, { nargs = 0 })

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

-- delete no name buffer
function _G.DeleteNoNameBuffer ()
  local noNameList = Filter(function (v)
    return vim.fn.bufname(v) == ''
  end, vim.fn.range(1, vim.fn.bufnr('$')))
  for i = 1, #noNameList do
    vim.cmd('bdelete '..noNameList[i])
  end
end

