
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
    local fileName = vim.fn.expand('%:t')
    local fullPath = vim.fn.expand('%:p')
    vim.cmd('silent! /'..fileName)
    vim.cmd('tabnew | GinLog -- '..fullPath)
  end
  , { nargs = 0 }
)
_G.TKC.plugins = _G.TKC.plugins or {}
_G.TKC.plugins.gin = _G.TKC.plugins.gin or {}
_G.TKC.plugins.gin.my_gin_diff = function (preCommit, postCommit, path)
  if preCommit == nil or postCommit == nil or path == nil then
    _G.TKC.utils.message.error('plugins.ddu.my_gin_diff some arg is nil', {
      preCommit = preCommit or ''
      , postCommit = postCommit or ''
      , path = path or ''
    })
    return
  end
  vim.cmd('GinEdit ++opener=tabnew '..preCommit..' '..path..'|diffthis')
  vim.bo.filetype = 'gin-my-patch'
  vim.cmd('GinEdit ++opener=vsplit '..postCommit..' '..path..'|diffthis')
  vim.bo.filetype = 'gin-my-patch'
end
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
