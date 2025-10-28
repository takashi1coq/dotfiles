
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

vim.schedule(function() _G.TKC.plugins.mr.open_mrw_file() end)

math.randomseed(os.time())
