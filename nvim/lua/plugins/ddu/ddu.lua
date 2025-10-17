
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
  }
})

-- ##################################
-- # ff
-- ##################################
vim.keymap.set('n', '<Space>u', function ()
  vim.fn['ddu#start']({
    ui = 'ff'
    , sources = {{ name = 'file_rec' }}
    , sourceOptions = {
      file_rec = {
        path = vim.fn.getcwd()
      }
    }
  })
end)
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
vim.keymap.set('n', '<Space>b', function ()
  local selects = {}
  local buffers = vim.api.nvim_list_bufs()
  for _, buf in ipairs(buffers) do
    local name = vim.api.nvim_buf_get_name(buf)
    if name ~= '' and vim.bo[buf].buflisted then
      name = vim.fn.fnamemodify(name, ":.")
      local modified = vim.bo[buf].modified and '+' or ' '
      local current = (buf == vim.api.nvim_get_current_buf()) and '%' or ' '
      table.insert(selects, {
        string.format([[%s %s %-30s]], modified, current, [["]]..name..[["]])
        , function () _G.TKC.utils.nvim.open_tab(vim.fn.fnameescape(name)) end
      })
    end
  end
  _G.TKC.plugins.ddu.open_custom_list(selects, false)
end)
vim.keymap.set('n', '<Space>m', function ()
  local selects = {}
  local mr = vim.fn['mr#mrw#list']()
  for _, path in ipairs(mr) do
    table.insert(selects, {
      path
      , function () _G.TKC.utils.nvim.open_tab(path) end
    })
  end
  _G.TKC.plugins.ddu.open_custom_list(selects, false)
end)
vim.keymap.set({'n', 'v'}, '<Space>g', function () _G.TKC.plugins.ddu.ddu_grep('root grep: ', vim.fn.getcwd()) end)
vim.keymap.set({'n', 'v'}, '<Space>G', function () _G.TKC.plugins.ddu.ddu_grep('under grep: ', vim.fn.expand('%:p:h')) end)
vim.keymap.set('n', '<Space>r', function () vim.fn['ddu#start']({
  ui = 'ff', resume = 1
  , uiParams = { ff = { startFilter = false } }
}) end)

-- ##################################
-- # filer
-- ##################################
vim.keymap.set('n', '<Space>f', function () _G.TKC.plugins.ddu.open_current_ddu_filer() end)
vim.keymap.set('n', '<Space>w', function () _G.TKC.plugins.ddu.open_ddu_filer(vim.fn.expand('~/work')) end)
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
  vim.fn['ddu#ui#do_action']('quit')
  local name = 'filerTerminalOpen_'..args.context.path
  _G.TKC.utils.terminal.my(name, nil, args.context.path)
end)
vim.fn['ddu#custom#action']('ui', 'filer', 'explorerOpen', function (args)
  if vim.fn.has('mac') == 1 then
    vim.cmd('silent !open '..args.context.path)
  elseif vim.fn.has('win32') == 1 then
    vim.cmd('silent !start '..args.context.path)
  else
    _G.TKC.utils.message.error('plugins.ddu.explorerOpen faild')
  end
end)
vim.fn['ddu#custom#action']('ui', 'filer', 'createMyRoot', function (args)
  local path = args.context.path..'/.myRoot'
  vim.cmd('silent !touch '..path)
  vim.fn['ddu#redraw'](vim.b['ddu_ui_name'], {refreshItems = 1})
end)
vim.fn['ddu#custom#action']('ui', 'filer', 'dduFilerDiff', function ()
  local path = vim.fn['ddu#ui#get_item']().treePath
  if (_G.TKC.utils.string.is_empty(vim.g.diffA)) or vim.g.diffA == path then
    vim.g.diffA = path
    print('diffA => [ '..vim.g.diffA..' ]')
  else
    vim.cmd('tabnew '..vim.g.diffA..'|diffthis')
    vim.cmd('vsplit '..path..'|diffthis')
    vim.g.diffA = ''
    print('diffA => [ '..vim.g.diffA..' ]')
  end
end)

-- TODO
vim.api.nvim_create_user_command(
  'OpenTerminal'
  , function ()
    vim.fn['ddu#ui#do_action']('terminalOpen')
  end
  , { nargs = 0 }
)
vim.api.nvim_create_user_command(
  'OpenExplorer'
  , function ()
    vim.fn['ddu#ui#do_action']('explorerOpen')
  end
  , { nargs = 0 }
)

vim.keymap.set('n', '<Space>c', function ()
  _G.TKC.plugins.ddu.open_custom_list({
    {
      'File : ~/.config/nvim/lua/local.lua'
      , function () _G.TKC.utils.nvim.open_tab('~/.config/nvim/lua/local.lua') end
    }
    , {
      'File : ~/.zshrc'
      , function () _G.TKC.utils.nvim.open_tab('~/.zshrc') end
    }
    , {
      'File : ~/.bashrc'
      , function () _G.TKC.utils.nvim.open_tab('~/.bashrc') end
    }
    , {
      'File : ~/.gitconfig.local'
      , function () _G.TKC.utils.nvim.open_tab('~/.gitconfig.local') end
    }
    , {
      'File : ~/.ssh/config'
      , function () _G.TKC.utils.nvim.open_tab('~/.ssh/config') end
    }
    , {
      'File : /etc/profile (read only)'
      , function ()
        local path = '/etc/profile'
        _G.TKC.utils.nvim.clipboard('sudo nvim '..path)
        _G.TKC.utils.nvim.open_tab(path)
      end
    }
    , {
      'File : /etc/hosts (read only)'
      , function ()
        local path = '/etc/hosts'
        _G.TKC.utils.nvim.clipboard('sudo nvim '..path)
        _G.TKC.utils.nvim.open_tab(path)
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
      , function ()
        _G.TKC.utils.terminal.my('myCommand', 'lsof -i :', nil, 'botright new')
      end
    }
    , {
      'Command : Docker prune [docker system prune] (yank)'
      , function () _G.TKC.utils.nvim.clipboard('docker system prune') end
    }
    , {
      'Command : Docker prune [docker compose build --no-cache] (yank)'
      , function () _G.TKC.utils.nvim.clipboard('docker-compose build --no-cache') end
    }
    , {
      'Command : File permission chmod [chmod u+x <FILE>] (open bottom terminal)'
      , function ()
        _G.TKC.utils.terminal.my('myCommand', 'chmod u+x ', nil, 'botright new')
      end
    }
    -- TODO create sort and diff function
    , {
      'Command : Sort File [LANG=C sort <Raw File> > <Sort File>] (yank)'
      , function () _G.TKC.utils.nvim.clipboard('LANG=C sort ') end
    }
    , {
      'Command : Outputs the difference in both file [comm -3 <A File> <B File>] (yank)'
      , function () _G.TKC.utils.nvim.clipboard('comm -3 ') end
    }
    , {
      'Command : Big file split [split -l 10000 <File>] (yank)'
      , function () _G.TKC.utils.nvim.clipboard('split -l 10000 ') end
    }
    , {
      [[Command : jq command [jq '.[]' *.json > filename.json] (yank)]]
      , function () _G.TKC.utils.nvim.clipboard([[jq '.[]' *.json > filename.json]]) end
    }
    , {
      [[Command : yq command csv to json [yq file.csv -p=csv -o=json > file.json] (yank)]]
      , function () _G.TKC.utils.nvim.clipboard([[yq file.csv -p=csv -o=json > file.json]]) end
    }
    , {
      'Command : Create large file [dd if=/dev/zero of=<filename> bs=1M count=25] (yank)'
      , function ()
        _G.TKC.utils.nvim.clipboard('dd if=/dev/zero of=<filename> bs=1M count=25')
        print('Please setup filename')
      end
    }
  })
end)

-- set augroup
_G.TKC.utils.nvim.create_augroup(require('plugins.ddu.augroup'), 'ddu_augroup')
-- set function
_G.TKC = _G.TKC or {}
_G.TKC.plugins = _G.TKC.plugins or {}
_G.TKC.plugins.ddu = require('plugins.ddu.function')


