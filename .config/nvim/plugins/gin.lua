local fileType = {}

-- status
vim.keymap.set('n', '<Space>l', function () vim.cmd('GinStatus ++opener=tabnew') end)
vim.g.gin_status_disable_default_mappings = true
fileType['gin-status'] = function ()
  vim.fn.bufferKeymapSet('n', 'dd'
    , function ()
      vim.cmd([[execute "normal \<Plug>(gin-action-yank:path)"]])
      local path = vim.fn.getreg('+')
      vim.cmd('Gin checkout -- '..path)
      -- TODO untracked file...
    end
  )
  vim.fn.bufferKeymapSet({'n','v'}, 'cc', '<Plug>(gin-action-patch:worktree)')
  vim.fn.bufferKeymapSet({'n','v'}, '<CR>', '<Plug>(gin-action-edit:local)')
  vim.fn.bufferKeymapSet({'n','v'}, '<<', '<Plug>(gin-action-stage)')
  vim.fn.bufferKeymapSet({'n','v'}, '==', '<Plug>(gin-action-stash)')
  vim.fn.bufferKeymapSet({'n','v'}, '>>', '<Plug>(gin-action-unstage)')
  vim.fn.bufferKeymapSet({'n','v'}, 'yy', '<Plug>(gin-action-yank:path)')
  vim.fn.bufferKeymapSet({'n','v'}, 'a', '<Plug>(gin-action-choice)')

  vim.api.nvim_create_user_command(
    'Commit'
    , function ()
      vim.cmd('Gin commit')
    end
    , { nargs = 0 }
  )
end

-- log
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
local function myGinDiff(preCommit, postCommit, path)
  if preCommit == nil or postCommit == nil or path == nil then
    print('myGinDiff nil error')
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
    local postBranchName = table.commandResultAsTable('git rev-parse --abbrev-ref HEAD')[1]
    local preCommit = table.commandResultAsTable([[git log -1 --format=%H ]]..preBranchName..[[ -- ]]..fullPath)[1]
    local postCommit = table.commandResultAsTable([[git log -1 --format=%H ]]..postBranchName..[[ -- ]]..fullPath)[1]
    myGinDiff(preCommit, postCommit, fullPath)
  end
  , { nargs = '*' }
)
vim.g.gin_log_disable_default_mappings = true
fileType['gin-log'] = function ()
  vim.fn.bufferKeymapSet('n', 'a', '<Plug>(gin-action-choice)')
  vim.fn.bufferKeymapSet('n', 'yy', '<Plug>(gin-action-yank:commit)')
  vim.fn.bufferKeymapSet('n', 'ch', function ()
    vim.cmd([[execute "normal \<Plug>(gin-action-yank:commit)"]])
    local commit = vim.fn.getreg('+')
    vim.cmd('GinBuffer ++opener=split diff '..commit..'^ '..commit..' --name-only')
    vim.bo.filetype = 'gin-my-log-changes'
    vim.g.changes_git_commit = commit
  end)
end
fileType['gin-my-log-changes'] = function ()
  vim.fn.bufferKeymapSet('n', 'cc', function ()
    local path = vim.fn.getline('.')
    myGinDiff(vim.g.changes_git_commit..'^', vim.g.changes_git_commit, path)
  end)
  vim.fn.bufferKeymapSet('n', '<CR>', function ()
    -- TODO first commit can not see..?
    local path = vim.fn.getline('.')
    vim.cmd('GinEdit ++opener=tabnew '..vim.g.changes_git_commit..'^ '..path)
  end)
end

-- blame
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

-- branch
vim.keymap.set('n', '<Space>k', function () vim.cmd('GinBranch ++opener=tabnew -a') end)
vim.g.gin_branch_disable_default_mappings = true
fileType['gin-branch'] = function ()
  vim.fn.bufferKeymapSet('n', '<CR>', '<Plug>(gin-action-switch)')
  vim.fn.bufferKeymapSet('n', 'nn', '<Plug>(gin-action-new)')
  vim.fn.bufferKeymapSet({'n','v'}, 'yy', '<Plug>(gin-action-yank:branch)')
  vim.fn.bufferKeymapSet({'n','v'}, 'a', '<Plug>(gin-action-choice)')
  vim.fn.bufferKeymapSet({'n','v'}, 'dd', '<Plug>(gin-action-delete)')
end

-- stash
vim.api.nvim_create_user_command('StashSave', function () vim.cmd('Gin stash save -u "gina stash"') end, { nargs = 0 })
vim.api.nvim_create_user_command('StashPop', function () vim.cmd('Gin stash pop') end, { nargs = 0 })
vim.api.nvim_create_user_command('StashList', function () vim.cmd('Gin stash list') end, { nargs = 0 })
vim.api.nvim_create_user_command('StashClear', function () vim.cmd('Gin stash clear') end, { nargs = 0 })

-- set keymap
vim.fn.createFileTypeAugroup(fileType, 'gin_augroup')
