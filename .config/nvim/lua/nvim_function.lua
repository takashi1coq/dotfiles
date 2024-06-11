-- filter buflist number by matching bufname
local function filterBuflistNumberByMatchingBufname(bufname)
  return table.filter(function (v)
    local firstNumFound = string.myFind(vim.fn.bufname(v), bufname)
    return not(firstNumFound == nil)
  end, vim.fn.range(1, vim.fn.bufnr("$")))
end

-- store yank
vim.fn.storeYank = function (word, printFlag)
  local w = tostring(word)
  vim.fn.setreg('+', w)
  vim.fn.setreg('"', w)
  if not(printFlag == nil) then
    print('yank word => [ '..w..' ]')
  end
end
-- path
vim.fn.projectFilePath = function ()
  return string.replace(vim.fn.expand('%:p'), vim.fn.getcwd()..'/', '')
end
vim.fn.fileName = function ()
  return table.explode(vim.fn.expand('%:t'), '.')[1]
end
vim.fn.fullFilePath = function ()
  return vim.fn.expand('%:p')
end
vim.fn.fullDirectryPath = function ()
  return vim.fn.expand('%:p:h')
end

-- open floating window
vim.fn.openFloatingWindowWithText = function (text, isLeftText)
  local lines = vim.fn.split(text, '\n')
  local buf = vim.api.nvim_create_buf(false, true)
  local originalWinSize = vim.api.nvim_win_get_width(0)
  local heightTable = {}
  local max_width = 0
  local col = (isLeftText == 'left') and 1 or originalWinSize - max_width
  for _, line in ipairs(lines) do
    local line_width = vim.fn.strdisplaywidth(line)
    if line_width > max_width then
        max_width = line_width
    end
    local index = 1
    while index <= vim.fn.strdisplaywidth(line) do
      table.insert(heightTable, line:sub(index, index + originalWinSize - 1))
      index = index + originalWinSize
    end
  end
  local height = #heightTable
  vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
  local win_id = vim.api.nvim_open_win(buf, true, {
      relative = 'editor',
      width = (max_width == 0) and 1 or max_width,
      height = (height == 0) and 1 or height,
      row = 1,
      col = col,
      style = 'minimal',
      border = 'single',
  })
  vim.api.nvim_win_set_option(win_id, 'wrap', true)
end
-- get visual
vim.fn.getVisual = function ()
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
vim.fn.setVisual = function (word)
  local w = tostring(word)
  local mode = vim.fn.mode()
  if mode == 'v' or mode == 'V' then
    local memo = vim.fn.getreginfo('z')
    vim.fn.setreg('z', w)
    vim.cmd('noautocmd normal! "zp')
    vim.fn.setreg('z', memo)
  end
end
-- file open
vim.fn.openFileInTab = function (f)
  vim.cmd('tabe '..vim.fn.expand(f))
end
-- get projectDirName
vim.fn.getProjectDirName = function ()
  local path = vim.fn.split(vim.fn.getcwd(), '/')
  return path[#path]
end
-- file type keymap set
vim.fn.createFileTypeAugroup = function (fileType, autocmdGroup)
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
vim.fn.bufferKeymapSet = function (type, key, fn, option)
  option = option or {}
  option['buffer'] = true
  vim.keymap.set(type, key, fn, option)
end
-- terminal
vim.fn.myTerminal = function (name, openNum, cmd, path)
  local bufOpenCmd = {
    'botright new'
    , '0tabnew'
  }
  local openBufnr = filterBuflistNumberByMatchingBufname(name)
  if not(table.isEmpty(openBufnr)) then
    if string.isEmpty(vim.fn.input('already exists. open buffer? : ')) then
      table.myForeach(function (v)
        local bufname = vim.fn.bufname(v)
        local num = string.sub(bufname, string.len(bufname))
        vim.fn.openEmptyBuffer(bufOpenCmd[tonumber(num)])
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
        vim.cmd('bd')
      end
      , on_stdout = function (id, data, event)
        -- TODO terminal log..?
      end
      , cwd = path
    }
  )
  vim.api.nvim_put({cmd}, 'c', false, true)
end
vim.keymap.set('n', '<Space>j', function () vim.fn.myTerminal('terminal_'..vim.fn.getProjectDirName(), 1, nil, nil) end)
vim.api.nvim_create_user_command('Terminal', function () vim.fn.myTerminal('Terminal', 2, nil, nil) end, { nargs = 0 })
-- quit
vim.fn.myQuit = function ()
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
-- open empty buffer (avoid E162)
vim.fn.openEmptyBuffer = function (opener)
  if opener == nil then
    opener = 'tabnew'
  end
  vim.cmd(opener..' | setlocal nobuflisted buftype=nofile bufhidden=wipe noswapfile')
end
-- create delimiter file
vim.fn.createDelimiterFile = function (path, data, count, sep)
  if path == nil then
    path = vim.fn.expand('~/Downloads/CreateDelimiterFile.csv')
  end
  if data == nil then
    data = {
      {
        'id'
        , function (i) return i end
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
  table.insert(t, string.implode(table.map(data, function (d)
    return d[1]
  end), sep))
  for i = 1, count do
    table.insert(t, string.implode(table.map(data, function (d)
      return d[2](i)
    end), sep))
  end
  local f = io.open(path, 'w')
  if f then
    f:write(string.implode(t, '\n'))
    f:close()
  end
  vim.cmd('tabe '..path)
end
