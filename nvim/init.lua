
local loader = require('loader')
_G.TKC = {}
_G.TKC.utils = loader.scan_dir(vim.fn.stdpath('config')..[[/lua/utils]])

require('core.commands')
require('core.autocmds')
require('core.options')
require('core.keymaps')

require("dein_init")

require("local")

vim.schedule(function()
  local openCount = _G.TKC.openCount or 1
  local excludedFiletypes = _G.TKC.excludedFiletypes or {
    'csv'
    , 'json'
  }
  local excludedExtensions = _G.TKC.excludedExtensions or {
    'log'
  }
  local ok, mr_function = pcall(require, 'plugins.mr.function')
  if ok then
    mr_function.open_mrw_file(openCount, excludedFiletypes, excludedExtensions)
  else
    vim.notify('mr function not found', vim.log.levels.ERROR)
  end
end)

