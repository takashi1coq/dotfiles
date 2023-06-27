local fileType = {}
-- ##################################
-- # global
-- ##################################
vim.fn['ddu#custom#patch_global']({
  ui = 'ff'
  , uiParams = {
    _ = {
      split = 'no'
    }
    , ff = {
      -- TODO preview
    }
    , filer = {
      sortTreesFirst = true
      , sort = 'filename'
    }
  }
  , sourceOptions = {
    _ = {
      ignoreCase = true
      , matchers = {'matcher_substring'}
    }
    , file = {
      columns = {'filename'}
    }
  }
  , sourceParams = {
    rg = {
      -- TODO '--color', 'always'
      args = {'--ignore-case', '--column', '--no-heading', '--hidden', '--glob', '!.git'}
    }
    , file_rec = {
      ignoredDirectories = {
        '.git', 'build', '__pycache__', 'node_modules'
      }
    }
  }
  , filterParams = {
    matcher_substring = {
      highlightMatched = 'Keyword'
    }
  }
  , kindOptions = {
    file = {
      defaultAction = 'open'
    }
    , ui_select = {
      defaultAction = 'select'
    }
  }
})

-- ##################################
-- # ff
-- ##################################
vim.keymap.set('n', '<Space>u', function () vim.fn['ddu#start']({
  ui = 'ff'
  , sources = {{ name = 'file_rec' }}
  , uiParams = { ff = { startFilter = true } }
}) end)
vim.keymap.set('n', '<Space>U', function () vim.fn['ddu#start']({
  ui = 'ff'
  , sources = {{ name = 'file_rec' }}
  , sourceOptions = {
    file_rec = {
      path = vim.fn.expand('%:p:h')
    }
  }
  , uiParams = { ff = { startFilter = true } }
}) end)
vim.keymap.set('n', '<Space>v', function () vim.fn['ddu#start']({
  ui = 'ff'
  , sources = {{ name = 'file_rec' }}
  , sourceOptions = {
    file_rec = {
      path = vim.fn.expand('~/dotfiles')
    }
  }
  , uiParams = { ff = { startFilter = true } }
}) end)
vim.keymap.set('n', '<Space>b', function () vim.fn['ddu#start']({
  ui = 'ff'
  , sources = {{ name = 'buffer' }}
}) end)
vim.keymap.set('n', '<Space>t', function ()
  local buffers = vim.api.nvim_list_bufs()
  for i in ipairs(buffers) do
    if not(vim.fn.buflisted(buffers[i]) == 0) then
      if next(vim.fn.win_findbuf(buffers[i])) == nil then
        vim.cmd('bd! '..buffers[i])
      end
    end
  end
  vim.fn['ddu#start']({
    ui = 'ff'
    , sources = {{ name = 'buffer' }}
  })
end)
vim.keymap.set('n', '<Space>m', function () vim.fn['ddu#start']({
  ui = 'ff'
  , sources = {{ name = 'mr', params = { kind = 'mrw' } }}
}) end)
local function dduGrep(inputTitle, path)
  local word = GetVisual()
  if IsEmpty(word) then
    word = vim.fn.input(inputTitle)
  end
  vim.cmd('silent! /'..word)
  vim.fn['ddu#start']({
    ui = 'ff'
    , sources = {{ name = 'rg', params = { input = word } }}
    , sourceOptions = {
      rg = {
        path = path
      }
    }
  })
end
vim.keymap.set({'n', 'v'}, '<Space>g', function () dduGrep('root grep: ', vim.fn.getcwd()) end)
vim.keymap.set({'n', 'v'}, '<Space>G', function () dduGrep('under grep: ', vim.fn.expand('%:p:h')) end)
vim.keymap.set('n', '<Space>r', function () vim.fn['ddu#start']({
  ui = 'ff', resume = 1
  , uiParams = { ff = { startFilter = false } }
}) end)
vim.keymap.set('n', '<Space>c', function ()
  local selects = {
    {
      'File : ~/.config/nvim/lua/local.lua'
      , function () FileOpen('~/.config/nvim/lua/local.lua') end
    }
    , {
      'File : ~/.zshrc'
      , function () FileOpen('~/.zshrc') end
    }
    , {
      'File : ~/.bashrc'
      , function () FileOpen('~/.bashrc') end
    }
    , {
      'File : ~/.gitconfig.local'
      , function () FileOpen('~/.gitconfig.local') end
    }
    , {
      'File : ~/.ssh/config'
      , function () FileOpen('~/.ssh/config') end
    }
    , {
      'File : /etc/profile (read only)'
      , function () FileOpen('/etc/profile') end
    }
    , {
      'File : /etc/hosts (read only)'
      , function () FileOpen('/etc/profile') end
    }
    , {
      'Dein : Dein Plugin Update'
      , function () vim.cmd('call dein#update()') end
    }
    , {
      'ExCmd : Toggle number setting :ToggleNumber'
      , function () vim.cmd('ToggleNumber') end
    }
    , {
      'Command : Find port prosess [lsof -i :<PORT>] (open bottom terminal)'
      , function () MyTerminal(1, 'lsof -i :', nil) end
    }
    , {
      'Command : Docker prune [docker system prune] (yank)'
      , function () StoreYank('docker system prune') end
    }
    , {
      'Command : File permission chmod [chmod u+x <FILE>] (open bottom terminal)'
      , function () MyTerminal(1, 'chmod u+x ', nil) end
    }
    -- TODO create sort and diff function
    , {
      'Command : Sort File [LANG=C sort <Raw File> > <Sort File>] (yank)'
      , function () StoreYank('LANG=C sort ') end
    }
    , {
      'Command : Outputs the difference in both file [comm -3 <A File> <B File>] (yank)'
      , function () StoreYank('comm -3 ') end
    }
    , {
      'Command : Big file split [split -l 10000 <File>] (yank)'
      , function () StoreYank('split -l 10000 ') end
    }
  }
  local selectName = Map(selects, function(v) return v[1] end)
  vim.ui.select(selectName, {}, function(c,i)
    selects[i][2]()
  end)
  -- TODO error when not selected
end)

fileType['ddu-ff'] = function ()
  VimBufferKeymapSet('n', '<CR>', function ()
    vim.fn['ddu#ui#do_action']('itemAction', { params = { command = 'tabedit' } })
  end)
  VimBufferKeymapSet('n', 'i', function ()
    vim.fn['ddu#ui#do_action']('openFilterWindow')
  end)
  VimBufferKeymapSet('n', 'dd', function ()
    -- TODO mr delete ..
    vim.fn['ddu#ui#do_action']('itemAction', { name = 'delete' })
  end)
--  VimBufferKeymapSet('n', 'p', function ()
--    vim.fn['ddu#ui#do_action']('preview')
--  end)
  VimBufferKeymapSet('n', 'q', function ()
    vim.fn['ddu#ui#do_action']('quit')
  end)
end
fileType['ddu-ff-filter'] = function ()
  VimBufferKeymapSet('i', '<CR>', '<Esc><Cmd>close<CR>')
  VimBufferKeymapSet('n', '<CR>', '<Cmd>close<CR>')
end

-- ##################################
-- # filer
-- ##################################
vim.keymap.set('n', '<Space>f', function () vim.fn['ddu#start']({
  ui = 'filer'
  , sources = {{ name = 'file', params = {} }}
  , sourceOptions = {
    file = {
      path = vim.fn.expand('%:p:h')
    }
  }
}) end)
vim.keymap.set('n', '<Space>w', function () vim.fn['ddu#start']({
  ui = 'filer'
  , sources = {{ name = 'file', params = {} }}
  , sourceOptions = {
    file = {
      path = vim.fn.expand('~/work')
    }
  }
}) end)
vim.keymap.set('n', '<Space>d', function () vim.fn['ddu#start']({
  ui = 'filer'
  , sources = {{ name = 'file', params = {} }}
  , sourceOptions = {
    file = {
      path = vim.fn.expand('~/Downloads')
    }
  }
  , uiParams = {
    filer = {
      sortTreesFirst = false
      , sort = 'TIME'
    }
  }
}) end)

vim.fn['ddu#custom#action']('ui', 'filer', 'terminalOpen', function (args)
  MyTerminal(1, nil, args.context.path)
end)

fileType['ddu-filer'] = function ()
  VimBufferKeymapSet('n', '<CR>', function ()
    vim.fn['ddu#ui#do_action']('itemAction', { name = 'open', params = { command = 'tabedit' } })
  end)
  VimBufferKeymapSet('n', 'yy', function ()
    vim.fn['ddu#ui#do_action']('itemAction', { name = 'copy' })
  end)
  VimBufferKeymapSet('n', 'p', function ()
    vim.fn['ddu#ui#do_action']('itemAction', { name = 'paste' })
  end)
  VimBufferKeymapSet('n', 'rr', function ()
    vim.fn['ddu#ui#do_action']('itemAction', { name = 'rename' })
  end)
  VimBufferKeymapSet('n', 'mm', function ()
    vim.fn['ddu#ui#do_action']('itemAction', { name = 'move' })
  end)
  VimBufferKeymapSet('n', 'dd', function ()
    vim.fn['ddu#ui#do_action']('itemAction', { name = 'delete' })
  end)
  VimBufferKeymapSet('n', 'ff', function ()
    vim.fn['ddu#ui#do_action']('itemAction', { name = 'newFile' })
  end)
  VimBufferKeymapSet('n', 'l', function ()
    vim.fn['ddu#ui#do_action']('itemAction', { name = 'narrow' })
  end)
  VimBufferKeymapSet('n', 'h', function ()
    vim.fn['ddu#ui#do_action']('itemAction', { name = 'narrow', params = { path = '..' } })
  end)
  VimBufferKeymapSet('n', 'q', function ()
    vim.fn['ddu#ui#filer#do_action']('quit')
  end)
  VimBufferKeymapSet('n', 't', function ()
    vim.fn['ddu#ui#filer#do_action']('terminalOpen')
  end)
  VimBufferKeymapSet('n', '<F4>', function ()
    vim.fn['ddu#redraw'](vim.b['ddu_ui_name'], {refreshItems = 1})
  end)
end

SetFileTypeKeyMap(fileType, 'ddu_augroup')
