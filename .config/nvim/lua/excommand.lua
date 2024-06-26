vim.api.nvim_create_user_command(
  'CopyPath'
  , function ()
    vim.fn.storeYank(vim.fn.projectFilePath(), true)
  end
  , { nargs = 0 }
)
vim.api.nvim_create_user_command(
  'CopyFileName'
  , function ()
    vim.fn.storeYank(vim.fn.fileNameExcludeExtension(), true)
  end
  , { nargs = 0 }
)
vim.api.nvim_create_user_command(
  'CopyFullPath'
  , function ()
    vim.fn.storeYank(vim.fn.fullFilePath(), true)
  end
  , { nargs = 0 }
)

vim.api.nvim_create_user_command(
  'Capture'
  , function (opts)
    vim.fn.openFloatingWindowWithText(vim.fn.execute(opts.args), 'left')
  end
  , {
    nargs = '+'
    , complete = 'command'
  }
)

vim.api.nvim_create_user_command(
  'SeparatorChange'
  , function (opts)
    local function change(v, isPrev)
      v = (v == 'enter') and ((isPrev) and [[\n]] or [[\r]]) or v
      v = (v == 'space') and ' ' or v
      v = (v == 'tab') and '\t' or v
      v = (v == 'comma') and ',' or v
      v = (v == 'period') and '\\.' or v
      v = (v == 'colon') and ':' or v
      v = (v == 'semicolon') and ';' or v
      v = (v == 'empty') and '' or v
      return v
    end
    local prev = change(opts.fargs[1], true)
    local next = change(opts.fargs[2], false)
    vim.fn.execute('%s/'..prev..'/'..next..'/g')
  end
  , {
    nargs = '*'
    , complete = function (arg_lead)
      return vim.tbl_filter(
        function(item)
          return vim.startswith(item, arg_lead)
        end
        , {
          'tab'
          , 'enter'
          , 'space'
          , 'comma'
          , 'period'
          , 'colon'
          , 'semicolon'
          , 'empty'
        }
      )
    end
  }
)

vim.api.nvim_create_user_command(
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

vim.api.nvim_create_user_command(
  'ToggleNumber'
  , function ()
      vim.cmd('setlocal relativenumber!')
  end
  , { nargs = 0 }
)
vim.api.nvim_create_user_command(
  'ToggleKeywordHyphen'
  , function ()
    local bufnr = vim.fn.bufnr()
    local iskeyword = vim.api.nvim_buf_get_option(bufnr, 'iskeyword')
    local filterHyphenTable = table.filter(function (v)
      return v == '-'
    end, table.explode(iskeyword, ','))
    if table.isEmpty(filterHyphenTable) then
      vim.cmd('setlocal isk+=-')
      local updateIskeyword = vim.api.nvim_buf_get_option(bufnr, 'iskeyword')
      print('iskeyword => [ '..updateIskeyword..' ]')
    else
      vim.cmd('setlocal isk-=-')
      local updateIskeyword = vim.api.nvim_buf_get_option(bufnr, 'iskeyword')
      print('iskeyword => [ '..updateIskeyword..' ]')
    end
  end
  , { nargs = 0 }
)

vim.api.nvim_create_user_command(
  'Messages'
  , function () vim.cmd('Capture messages') end
  , { nargs = 0 }
)

vim.api.nvim_create_user_command(
  'DiffCheck'
  , function ()
    vim.fn.openEmptyBuffer('tabnew DiffA')
    vim.fn.openEmptyBuffer('vert diffsplit DiffB')
    vim.cmd('wincmd w')
  end
  , { nargs = 0 }
)


