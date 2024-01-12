local fileType = {}
-- ##################################
-- # global
-- ##################################
vim.fn['ddu#custom#patch_global']({
  ui = 'ff'
  , refresh = true
  , uiParams = {
    _ = {
      split = 'no'
    }
    , ff = {
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
  , sourceOptions = {
    file_rec = {
      path = vim.fn.getcwd()
    }
  }
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
-- ex. "(vim.*set)|(set.*vim)"
local function createPermutationGrepWord (t)
  local b = {}
  for p in os.permutation(t) do
    local str = string.implode(p, '.*')
    table.insert(b, str)
  end
  return '('..string.implode(b, ')|(')..')'
end
local function dduGrep(inputTitle, path)
  local word = vim.fn.getVisual()
  if string.isEmpty(word) then
    word = vim.fn.input(inputTitle)
    if string.isEmpty(word) then
      return
    end
  end
  local grepWord = createPermutationGrepWord(table.explode(word, ' '))
  vim.fn['ddu#start']({
    ui = 'ff'
    , uiParams = {
      ff = {
        autoAction = {
          name = 'preview'
        }
        , startAutoAction = true
        , previewSplit = 'vertical'
      }
    }
    , sources = {{ name = 'rg', params = { input = grepWord } }}
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

vim.fn.openDduSelect = function (selects)
  local selectName = table.map(selects, function(v) return v[1] end)
  vim.ui.select(selectName, {}, function(_,i)
    selects[i][2]()
  end)
  -- TODO error when not selected
end

vim.keymap.set('n', '<Space>c', function ()
  vim.fn.openDduSelect({
    {
      'File : ~/.config/nvim/lua/local.lua'
      , function () vim.fn.openFileInTab('~/.config/nvim/lua/local.lua') end
    }
    , {
      'File : ~/.zshrc'
      , function () vim.fn.openFileInTab('~/.zshrc') end
    }
    , {
      'File : ~/.bashrc'
      , function () vim.fn.openFileInTab('~/.bashrc') end
    }
    , {
      'File : ~/.gitconfig.local'
      , function () vim.fn.openFileInTab('~/.gitconfig.local') end
    }
    , {
      'File : ~/.ssh/config'
      , function () vim.fn.openFileInTab('~/.ssh/config') end
    }
    , {
      'File : /etc/profile (read only)'
      , function ()
        local path = '/etc/profile'
        vim.fn.storeYank('sudo nvim '..path)
        vim.fn.openFileInTab(path)
      end
    }
    , {
      'File : /etc/hosts (read only)'
      , function ()
        local path = '/etc/hosts'
        vim.fn.storeYank('sudo nvim '..path)
        vim.fn.openFileInTab(path)
      end
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
      , function () vim.fn.myTerminal('myCommand', 1, 'lsof -i :', nil) end
    }
    , {
      'Command : Docker prune [docker system prune] (yank)'
      , function () vim.fn.storeYank('docker system prune') end
    }
    , {
      'Command : File permission chmod [chmod u+x <FILE>] (open bottom terminal)'
      , function () vim.fn.myTerminal('myCommand', 1, 'chmod u+x ', nil) end
    }
    -- TODO create sort and diff function
    , {
      'Command : Sort File [LANG=C sort <Raw File> > <Sort File>] (yank)'
      , function () vim.fn.storeYank('LANG=C sort ') end
    }
    , {
      'Command : Outputs the difference in both file [comm -3 <A File> <B File>] (yank)'
      , function () vim.fn.storeYank('comm -3 ') end
    }
    , {
      'Command : Big file split [split -l 10000 <File>] (yank)'
      , function () vim.fn.storeYank('split -l 10000 ') end
    }
    , {
      [[Command : jq command [jq '.[]' *.json > filename.json] (yank)]]
      , function () vim.fn.storeYank([[jq '.[]' *.json > filename.json]]) end
    }
  })
end)

fileType['ddu-ff'] = function ()
  vim.fn.bufferKeymapSet('n', '<CR>', function ()
    vim.fn['ddu#ui#do_action']('itemAction', { params = { command = 'tabedit' } })
  end)
  vim.fn.bufferKeymapSet('n', 'i', function ()
    vim.fn['ddu#ui#do_action']('openFilterWindow')
  end)
  vim.fn.bufferKeymapSet('n', 'dd', function ()
    -- TODO mr delete ..
    vim.fn['ddu#ui#do_action']('itemAction', { name = 'delete' })
  end)
  vim.fn.bufferKeymapSet('n', 'q', function ()
    vim.fn['ddu#ui#do_action']('quit')
  end)
end
fileType['ddu-ff-filter'] = function ()
  vim.fn.bufferKeymapSet('i', '<CR>', '<Esc><Cmd>close<CR>')
  vim.fn.bufferKeymapSet('n', '<CR>', '<Cmd>close<CR>')
end

-- ##################################
-- # filer
-- ##################################
vim.fn.openDduFiler = function (path)
  vim.fn['ddu#start']({
    ui = 'filer'
    , sources = {{ name = 'file', params = {} }}
    , sourceOptions = {
      file = {
        path = path
      }
    }
  })
end

local function dduFiler()
  local filename = vim.fn.expand('%:t')
  filename = table.explode(filename, '.')[1]
  vim.cmd('silent! /'..filename)
  vim.fn.openDduFiler(vim.fn.expand('%:p:h'))
end

vim.keymap.set('n', '<Space>f', function () dduFiler() end)
vim.keymap.set('n', '<Space>w', function () vim.fn.openDduFiler(vim.fn.expand('~/work')) end)
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
  vim.fn.myTerminal('filerTerminalOpen', 2, nil, args.context.path)
end)
vim.fn['ddu#custom#action']('ui', 'filer', 'explorerOpen', function (args)
  vim.cmd('silent !open '..args.context.path)
end)
vim.fn['ddu#custom#action']('ui', 'filer', 'createMyRoot', function (args)
  local path = args.context.path..'/.myRoot'
  vim.cmd('silent !touch '..path)
  vim.fn['ddu#redraw'](vim.b['ddu_ui_name'], {refreshItems = 1})
end)

fileType['ddu-filer'] = function ()
  vim.fn.bufferKeymapSet('n', '<CR>', function ()
    vim.fn['ddu#ui#do_action']('itemAction', { name = 'open', params = { command = 'tabedit' } })
  end)
  vim.fn.bufferKeymapSet('n', 'yy', function ()
    vim.fn['ddu#ui#do_action']('itemAction', { name = 'copy' })
  end)
  vim.fn.bufferKeymapSet('n', 'p', function ()
    vim.fn['ddu#ui#do_action']('itemAction', { name = 'paste' })
  end)
  vim.fn.bufferKeymapSet('n', 'rr', function ()
    vim.fn['ddu#ui#do_action']('itemAction', { name = 'rename' })
  end)
  vim.fn.bufferKeymapSet('n', 'mm', function ()
    vim.fn['ddu#ui#do_action']('itemAction', { name = 'move' })
  end)
  vim.fn.bufferKeymapSet('n', 'dd', function ()
    vim.fn['ddu#ui#do_action']('itemAction', { name = 'delete' })
  end)
  vim.fn.bufferKeymapSet('n', 'N', function ()
    vim.fn['ddu#ui#do_action']('itemAction', { name = 'newFile' })
  end)
  vim.fn.bufferKeymapSet('n', 'D', function ()
    vim.fn['ddu#ui#do_action']('itemAction', { name = 'newDirectory' })
  end)
  vim.fn.bufferKeymapSet('n', '.', function ()
    vim.fn['ddu#ui#filer#do_action']('createMyRoot')
  end)
  vim.fn.bufferKeymapSet('n', 'l', function ()
    vim.fn['ddu#ui#do_action']('itemAction', { name = 'narrow' })
  end)
  vim.fn.bufferKeymapSet('n', 'h', function ()
    vim.fn['ddu#ui#do_action']('itemAction', { name = 'narrow', params = { path = '..' } })
  end)
  vim.fn.bufferKeymapSet('n', 'q', function ()
    vim.fn['ddu#ui#filer#do_action']('quit')
  end)
  vim.fn.bufferKeymapSet('n', 't', function ()
    vim.fn['ddu#ui#filer#do_action']('terminalOpen')
  end)
  vim.fn.bufferKeymapSet('n', 'e', function ()
    vim.fn['ddu#ui#filer#do_action']('explorerOpen')
  end)
  vim.fn.bufferKeymapSet('n', '<F4>', function ()
    vim.fn['ddu#redraw'](vim.b['ddu_ui_name'], {refreshItems = 1})
  end)
end

-- TODO
vim.api.nvim_create_user_command(
  'OpenTerminal'
  , function ()
    vim.fn['ddu#ui#filer#do_action']('terminalOpen')
  end
  , { nargs = 0 }
)
vim.api.nvim_create_user_command(
  'OpenExplorer'
  , function ()
    vim.fn['ddu#ui#filer#do_action']('explorerOpen')
  end
  , { nargs = 0 }
)

vim.fn.createFileTypeAugroup(fileType, 'ddu_augroup')
