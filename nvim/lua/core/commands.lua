
local function create_desc(text)
  return _G.TKC.utils.string.separator..text
end
vim.api.nvim_create_user_command(
  'CopyPath'
  , function (opts)
    local arg = (opts.args ~= "" and opts.args) or 'relative_path'
    if arg == 'relative_path' then
      _G.TKC.utils.nvim.clipboard(_G.TKC.utils.file.current_relative_path(), true)
    elseif arg == 'file_stem' then
      _G.TKC.utils.nvim.clipboard(_G.TKC.utils.file.current_file_stem(), true)
    elseif arg == 'directory' then
      _G.TKC.utils.nvim.clipboard(_G.TKC.utils.file.current_directory_path(), true)
    elseif arg == 'full_path' then
      _G.TKC.utils.nvim.clipboard(_G.TKC.utils.file.current_file_path(), true)
    end
  end
  , {
    nargs = '?'
    , complete = _G.TKC.utils.nvim.command_complete({
      'relative_path'
      , 'file_stem'
      , 'directory'
      , 'full_path'
    })
    , desc = create_desc('get current file path in multiple formats')
  }
)
vim.api.nvim_create_user_command(
  'OutputInFloating'
  , function (opts)
    _G.TKC.utils.nvim.open_floating_window_with_text(vim.fn.execute(opts.args))
  end
  , {
    nargs = '+'
    , complete = 'command'
    , desc = create_desc('excommand result putput in floating')
  }
)
vim.api.nvim_create_user_command(
  'ChengeSeparator'
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
    vim.cmd('nohlsearch')
  end
  , {
    nargs = '*'
    , complete = _G.TKC.utils.nvim.command_complete({
      'tab'
      , 'enter'
      , 'space'
      , 'comma'
      , 'period'
      , 'colon'
      , 'semicolon'
      , 'empty'
    })
    , desc = create_desc('change separator of current buffer')
  }
)
vim.api.nvim_create_user_command(
  'ToggleNumber'
  , function ()
      vim.cmd('setlocal relativenumber!')
  end
  , {
    nargs = 0
    , desc = create_desc('toggle relativenumber')
  }
)
vim.api.nvim_create_user_command(
  'DiffCheck'
  , function ()
    _G.TKC.utils.nvim.diff()
  end
  , {
    nargs = 0
    , desc = create_desc('open two empty buffers and perform diff')
  }
)
vim.api.nvim_create_user_command(
  'Macro'
  , function (opts)
    local arg = (opts.args ~= "" and opts.args) or 'end'
    if arg == 'start' then
      vim.api.nvim_feedkeys('qm', 'n', true)
    elseif arg == 'run' then
      vim.api.nvim_feedkeys('@m', 'n', true)
    elseif arg == 'stop' then
      if vim.fn.reg_recording() ~= '' then
        vim.api.nvim_feedkeys('q', 'n', true)
      end
    end
  end
  , {
    nargs = '?'
    , complete = _G.TKC.utils.nvim.command_complete({
      'start'
      , 'run'
      , 'stop'
    })
    , desc = create_desc('macro start, run, stop')
  }
)
vim.api.nvim_create_user_command(
  'ReloadAll'
  , function ()
    _G.TKC.utils.nvim.reload()
  end
  , {
    nargs = 0
    , desc = create_desc('vim reload (unsafe method)')
  }
)
vim.api.nvim_create_user_command(
  'Terminal'
  , function ()
    _G.TKC.utils.terminal.my('Vanilla')
  end
  , {
    nargs = 0
    , desc = create_desc('open terminal in tab')
  }
)
vim.api.nvim_create_user_command(
  'RandomString'
  , function ()
    _G.TKC.utils.nvim.clipboard(_G.TKC.utils.string.random(10), true)
  end
  , {
    nargs = 0
    , desc = create_desc('copy 10 character rundom string to clipboard')
  }
)
vim.api.nvim_create_user_command(
  'DeinUpdate'
  , function ()
    vim.cmd('call dein#update()')
  end
  , {
    nargs = 0
    , desc = create_desc('Dein Plugin Update')
  }
)
