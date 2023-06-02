
local myCommand = vim.api.nvim_create_user_command

myCommand(
  'CopyPath'
  , function ()
    local path = vim.fn.expand('%:p')
    path = path:gsub(vim.fn.getcwd()..'/', '')
    StoreYank(path)
  end
  , { nargs = 0 }
)
myCommand(
  'CopyFileName'
  , function ()
    local filename = vim.fn.expand('%:t')
    filename = Explode(filename, '.')[1]
    StoreYank(filename)
  end
  , { nargs = 0 }
)

myCommand(
  'Capture'
  , function (opts)
    local buf = OpenFloatingWindow()
    local result = vim.fn.split(vim.fn.execute(opts.args), '\n')
    vim.api.nvim_buf_set_lines(buf, 0, -1, false, result)
  end
  , {
    nargs = '+'
    , complete = 'command'
  }
)

myCommand(
  'SeparatorChange'
  , function (opts)
    local function change(v)
      v = (v == 'space') and ' ' or v
      v = (v == 'tab') and '\t' or v
      v = (v == 'enter') and '\r' or v
      v = (v == 'comma') and ',' or v
      v = (v == 'period') and '\\.' or v
      v = (v == 'colon') and ':' or v
      v = (v == 'semicolon') and ';' or v
      return v
    end
    local prev = change(opts.fargs[1])
    local next = change(opts.fargs[2])

    vim.fn.execute('%s/'..prev..'/'..next..'/g')
  end
  , {
    nargs = '*'
    , complete = function ()
      return {
        'tab'
        , 'enter'
        , 'space'
        , 'comma'
        , 'period'
        , 'colon'
        , 'semicolon'
      }
    end
  }
)

myCommand(
  'WinOne'
  , function ()
    local winId = vim.fn.win_getid()
    local winList = vim.fn.win_findbuf(vim.fn.bufnr('%'))
    for i in ipairs(winList) do
      if not(winList[i] == winId) then
        vim.fn.win_gotoid(winList[i])
        vim.cmd('q')
      end
    end
    vim.fn.win_gotoid(winId)
  end
  , { nargs = 0 }
)

myCommand(
  'MyQuit'
  , function ()
    if vim.fn.winnr('$') == 1
    and vim.fn.tabpagenr('$') > 1
    and vim.fn.tabpagenr() > 1
    and vim.fn.tabpagenr() < vim.fn.tabpagenr("$") then
      vim.cmd('tabclose|tabprev')
    else
      vim.cmd('q')
    end
  end
  , { nargs = 0 }
)

myCommand(
  'ToggleNumber'
  , function ()
      vim.cmd('setlocal relativenumber!')
  end
  , { nargs = 0 }
)

myCommand(
  'Messages'
  , function () vim.cmd('Capture messages') end
  , { nargs = 0 }
)

-- translate-shell
vim.keymap.set(
  'v', '<F1>'
  , function ()
    local visualStr = GetVisual()
    visualStr = visualStr:gsub('"', '')
    local result = vim.fn.system('trans -b -sl=en -tl=ja '.. '"'.. visualStr.. '"')
    result = result:gsub('\n', '')
    local buf = OpenFloatingWindow()
    vim.api.nvim_buf_set_lines(buf, 0, -1, false, {result})
  end
)

-- refresh
vim.keymap.set(
  'n', '<F4>'
  , function ()
    local tabnr = vim.fn.tabpagenr()
    vim.cmd('tabdo e!')
    vim.cmd('tabnext '..tabnr)

    local bufnrs = vim.fn.range(1, vim.fn.bufnr("$"))
    local deleteBufners = Filter(function (v)
      local isBufexists = vim.fn.bufexists(vim.fn.bufname(v)) == 1
      local isFilereadable = vim.fn.filereadable(vim.fn.expand("#"..v..":p")) == 1
      local isBuflisted = vim.fn.buflisted(v) == 1
      local isTerminal = vim.fn.getbufvar(v, '&buftype') == 'terminal'
      return isBufexists and not(isFilereadable) and isBuflisted and not(isTerminal)
    end, bufnrs)
    for i in ipairs(deleteBufners) do
      vim.cmd('bd '..deleteBufners[i])
    end
  end
)
