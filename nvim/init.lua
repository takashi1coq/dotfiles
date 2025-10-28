
local loader = require('loader')
_G.TKC = {}
_G.TKC.utils = loader.scan_dir(vim.fn.stdpath('config')..[[/lua/utils]])

local function pcall_require(arg)
  local ok, mod_or_err = pcall(require, arg)
  if not ok then
    vim.notify('Error pcall_require : '..mod_or_err, vim.log.levels.ERROR)
  end
end

pcall_require('core.commands')
pcall_require('core.autocmds')
pcall_require('core.options')
pcall_require('core.keymaps')

pcall_require('dein_init')

pcall_require('local')

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

math.randomseed(os.time())
