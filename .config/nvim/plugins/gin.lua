local fileType = {}

-- status
vim.keymap.set('n', '<Space>l', function () vim.cmd('GinStatus ++opener=tabnew') end)
vim.g.gin_status_disable_default_mappings = true
fileType['gin-status'] = function ()
  VimBufferKeymapSet('n', 'dd'
    , function ()
      vim.cmd([[execute "normal \<Plug>(gin-action-yank:path)"]])
      local path = vim.fn.getreg('+')
      vim.cmd('Gin checkout -- '..path)
      -- TODO untracked file...
    end
  )
  VimBufferKeymapSet({'n','v'}, 'cc', '<Plug>(gin-action-patch:worktree)')
  VimBufferKeymapSet({'n','v'}, '<CR>', '<Plug>(gin-action-edit:local)')
  VimBufferKeymapSet({'n','v'}, '<<', '<Plug>(gin-action-stage)')
  VimBufferKeymapSet({'n','v'}, '==', '<Plug>(gin-action-stash)')
  VimBufferKeymapSet({'n','v'}, '>>', '<Plug>(gin-action-unstage)')
  VimBufferKeymapSet({'n','v'}, 'yy', '<Plug>(gin-action-yank:path)')
  VimBufferKeymapSet({'n','v'}, 'a', '<Plug>(gin-action-choice)')

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
    vim.cmd('silent! /'..vim.fn.expand('%:t'))
    vim.cmd('GinLog -- %')
  end
  , { nargs = 0 }
)
vim.g.gin_log_disable_default_mappings = true
fileType['gin-log'] = function ()
  VimBufferKeymapSet('n', 'a', '<Plug>(gin-action-choice)')
  VimBufferKeymapSet('n', 'yy', '<Plug>(gin-action-yank:commit)')
  VimBufferKeymapSet('n', 'ch', function ()
    vim.cmd([[execute "normal \<Plug>(gin-action-yank:commit)"]])
    local commit = vim.fn.getreg('+')
    vim.cmd('GinBuffer ++opener=split diff '..commit..'^ '..commit..' --name-only')
    vim.bo.filetype = 'gin-my-log-changes'
    vim.g.changes_git_commit = commit
  end)
end
fileType['gin-my-log-changes'] = function ()
  VimBufferKeymapSet('n', 'cc', function ()
    local path = vim.fn.getline('.')
    vim.cmd('GinEdit ++opener=tabnew '..vim.g.changes_git_commit..'^ '..path..'|diffthis')
    vim.bo.filetype = 'gin-my-patch'
    vim.cmd('GinEdit ++opener=vsplit '..vim.g.changes_git_commit..' '..path..'|diffthis')
    vim.bo.filetype = 'gin-my-patch'
  end)
  VimBufferKeymapSet('n', '<CR>', function ()
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
  VimBufferKeymapSet('n', '<CR>', '<Plug>(gin-action-switch)')
  VimBufferKeymapSet('n', 'nn', '<Plug>(gin-action-new)')
  VimBufferKeymapSet({'n','v'}, 'yy', '<Plug>(gin-action-yank:branch)')
  VimBufferKeymapSet({'n','v'}, 'a', '<Plug>(gin-action-choice)')
  VimBufferKeymapSet({'n','v'}, 'dd', '<Plug>(gin-action-delete)')
end

-- stash
vim.api.nvim_create_user_command('StashSave', function () vim.cmd('Gin stash save -u "gina stash"') end, { nargs = 0 })
vim.api.nvim_create_user_command('StashPop', function () vim.cmd('Gin stash pop') end, { nargs = 0 })
vim.api.nvim_create_user_command('StashList', function () vim.cmd('Gin stash list') end, { nargs = 0 })
vim.api.nvim_create_user_command('StashClear', function () vim.cmd('Gin stash clear') end, { nargs = 0 })

-- set keymap
SetFileTypeKeyMap(fileType, 'gin_augroup')
