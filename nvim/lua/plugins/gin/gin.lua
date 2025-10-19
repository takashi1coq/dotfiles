
--[[==========================================================
 status
============================================================]]
vim.keymap.set('n', '<Space>l', function () vim.cmd('GinStatus ++opener=tabnew') end)
vim.g.gin_status_disable_default_mappings = true

--[[==========================================================
 log
============================================================]]
vim.g.gin_log_default_args = {
  '++opener=tabnew'
  , '--graph'
  , '--decorate=full'
  , '--max-count=50'
}
vim.api.nvim_create_user_command(
  'LogBranch'
  , function () vim.cmd('GinLog '..vim.fn['gin#component#branch#unicode']()) end
  , { nargs = 0 }
)
vim.api.nvim_create_user_command(
  'LogCurrent'
  , function ()
    local relativePath = _G.TKC.utils.file.chenge_slash_for_unix(_G.TKC.utils.file.current_relative_path())
    _G.TKC.plugins.gin.log_current_path = relativePath
    _G.TKC.utils.os.dump(relativePath)
    vim.cmd('tabnew | GinLog -- '.._G.TKC.utils.file.current_file_path())
  end
  , { nargs = 0 }
)
vim.api.nvim_create_user_command(
  'LogCurrentBranch'
  , function (opts)
    local fullPath = vim.fn.expand('%:p')
    local preBranchName = (opts.fargs[1] == nil) and 'master' or opts.fargs[1]
    local postBranchName = _G.TKC.utils.os.execute_command_to_table('git rev-parse --abbrev-ref HEAD')[1]
    local preCommit = _G.TKC.utils.os.execute_command_to_table([[git log -1 --format=%H ]]..preBranchName..[[ -- ]]..fullPath)[1]
    local postCommit = _G.TKC.utils.os.execute_command_to_table([[git log -1 --format=%H ]]..postBranchName..[[ -- ]]..fullPath)[1]
    _G.TKC.plugins.gin.my_gin_diff(preCommit, postCommit, fullPath)
  end
  , { nargs = '*' }
)
vim.g.gin_log_disable_default_mappings = true

--[[==========================================================
 blame
============================================================]]
vim.api.nvim_create_user_command(
  'Blame'
  , function ()
    vim.cmd('GinBuffer ++opener=vsplit blame -M -n %')
    vim.wo.wrap = false
    vim.bo.filetype = 'my-gin-blame'
  end
  , { nargs = 0 }
)
-- TODO show commit message..

--[[==========================================================
 branch
============================================================]]
vim.keymap.set('n', '<Space>k', function () vim.cmd('GinBranch ++opener=tabnew -a') end)
vim.g.gin_branch_disable_default_mappings = true

-- stash
vim.api.nvim_create_user_command('StashSave', function () vim.cmd('Gin stash save -u "gina stash"') end, { nargs = 0 })
vim.api.nvim_create_user_command('StashPop', function () vim.cmd('Gin stash pop') end, { nargs = 0 })
vim.api.nvim_create_user_command('StashList', function () vim.cmd('Gin stash list') end, { nargs = 0 })
vim.api.nvim_create_user_command('StashClear', function () vim.cmd('Gin stash clear') end, { nargs = 0 })

-- set augroup keymap
_G.TKC.utils.nvim.create_augroup(require('plugins.gin.augroup'), 'gin_augroup')
-- set plugin erea
_G.TKC = _G.TKC or {}
_G.TKC.plugins = _G.TKC.plugins or {}
_G.TKC.plugins.gin = require('plugins.gin.function')
-- set highlight
vim.api.nvim_set_hl(0, "MyGinHighlight", { fg = "#ff6600", ctermfg = 1 })
