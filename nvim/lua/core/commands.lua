
vim.api.nvim_create_user_command(
  'CopyRelativePath'
  , function ()
    _G.TKC.utils.nvim.clipboard(_G.TKC.utils.file.current_relative_path(), true)
  end
  , { nargs = 0 }
)
vim.api.nvim_create_user_command(
  'CopyFileStem'
  , function ()
    _G.TKC.utils.nvim.clipboard(_G.TKC.utils.file.current_file_stem(), true)
  end
  , { nargs = 0 }
)
vim.api.nvim_create_user_command(
  'CopyDirectoryPath'
  , function ()
    _G.TKC.utils.nvim.clipboard(_G.TKC.utils.file.current_directory_path(), true)
  end
  , { nargs = 0 }
)
vim.api.nvim_create_user_command(
  'CopyFullPath'
  , function ()
    _G.TKC.utils.nvim.clipboard(_G.TKC.utils.file.current_file_path(), true)
  end
  , { nargs = 0 }
)
vim.api.nvim_create_user_command(
  'Capture'
  , function (opts)
    _G.TKC.utils.nvim.open_floating_window_with_text(vim.fn.execute(opts.args), 'left')
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
  'ToggleNumber'
  , function ()
      vim.cmd('setlocal relativenumber!')
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
    _G.TKC.utils.nvim.diff(nil, nil)
  end
  , { nargs = 0 }
)
vim.api.nvim_create_user_command(
  'MarkStart'
  , function ()
    vim.api.nvim_feedkeys('qm', 'n', true)
  end
  , { nargs = 0 }
)
vim.api.nvim_create_user_command(
  'MarkRun'
  , function ()
    vim.api.nvim_feedkeys('@m', 'n', true)
  end
  , { nargs = 0 }
)
vim.api.nvim_create_user_command(
  'ReloadAll'
  , function ()
    _G.TKC.utils.nvim.reload()
  end
  , { nargs = 0 }
)
vim.api.nvim_create_user_command(
  'Terminal'
  , function ()
    _G.TKC.utils.terminal.my('Vanilla', nil, nil)
  end
  , { nargs = 0 }
)
vim.api.nvim_create_user_command(
  'RandomString'
  , function ()
    _G.TKC.utils.nvim.clipboard(_G.TKC.utils.string.random(10))
  end
  , { nargs = 0 }
)

--vim.api.nvim_create_user_command(
--  'ToggleKeywordHyphen'
--  , function ()
--    local bufnr = vim.fn.bufnr()
--    local iskeyword = vim.api.nvim_buf_get_option(bufnr, 'iskeyword')
--    local filterHyphenTable = table.filter(function (v)
--      return v == '-'
--    end, table.explode(iskeyword, ','))
--    if table.isEmpty(filterHyphenTable) then
--      vim.cmd('setlocal isk+=-')
--      local updateIskeyword = vim.api.nvim_buf_get_option(bufnr, 'iskeyword')
--      print('iskeyword => [ '..updateIskeyword..' ]')
--    else
--      vim.cmd('setlocal isk-=-')
--      local updateIskeyword = vim.api.nvim_buf_get_option(bufnr, 'iskeyword')
--      print('iskeyword => [ '..updateIskeyword..' ]')
--    end
--  end
--  , { nargs = 0 }
--)

