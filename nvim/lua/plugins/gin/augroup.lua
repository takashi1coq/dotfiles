
return {
  ['gin-status'] = function ()
    _G.TKC.utils.nvim.buffer_keymap('n', 'dd'
      , function ()
        vim.cmd([[execute "normal \<Plug>(gin-action-yank:path)"]])
        local path = vim.fn.getreg('+')
        vim.cmd('Gin checkout -- '..path)
        -- TODO untracked file...
      end
    )
    _G.TKC.utils.nvim.buffer_keymap({'n','v'}, 'cc', '<Plug>(gin-action-patch:worktree)')
    _G.TKC.utils.nvim.buffer_keymap({'n','v'}, '<CR>', '<Plug>(gin-action-edit:local)')
    _G.TKC.utils.nvim.buffer_keymap({'n','v'}, '<<', '<Plug>(gin-action-stage)')
    _G.TKC.utils.nvim.buffer_keymap({'n','v'}, '==', '<Plug>(gin-action-stash)')
    _G.TKC.utils.nvim.buffer_keymap({'n','v'}, '>>', '<Plug>(gin-action-unstage)')
    _G.TKC.utils.nvim.buffer_keymap({'n','v'}, 'yy', '<Plug>(gin-action-yank:path)')
    _G.TKC.utils.nvim.buffer_keymap({'n','v'}, 'a', '<Plug>(gin-action-choice)')

    vim.api.nvim_create_user_command(
      'Commit'
      , function ()
        vim.cmd('Gin commit')
      end
      , { nargs = 0 }
    )
  end
  , ['gin-log'] = function ()
    _G.TKC.utils.nvim.buffer_keymap('n', 'a', '<Plug>(gin-action-choice)')
    _G.TKC.utils.nvim.buffer_keymap('n', 'yy', '<Plug>(gin-action-yank:commit)')
    _G.TKC.utils.nvim.buffer_keymap('n', 'ch', function ()
      vim.cmd([[execute "normal \<Plug>(gin-action-yank:commit)"]])
      local commit = vim.fn.getreg('+')
      vim.cmd('GinBuffer ++opener=split diff '..commit..'^ '..commit..' --name-only')
      vim.bo.filetype = 'gin-my-log-changes'
      vim.g.changes_git_commit = commit
    end)
  end
  , ['gin-my-log-changes'] = function ()
    _G.TKC.utils.nvim.buffer_keymap('n', 'cc', function ()
      local path = vim.fn.getline('.')
      _G.TKC.plugins.gin.my_gin_diff(vim.g.changes_git_commit..'^', vim.g.changes_git_commit, path)
    end)
    _G.TKC.utils.nvim.buffer_keymap('n', '<CR>', function ()
      -- TODO first commit can not see..?
      local path = vim.fn.getline('.')
      vim.cmd('GinEdit ++opener=tabnew '..vim.g.changes_git_commit..'^ '..path)
    end)
  end
  , ['gin-branch'] = function ()
    _G.TKC.utils.nvim.buffer_keymap('n', '<CR>', '<Plug>(gin-action-switch)')
    _G.TKC.utils.nvim.buffer_keymap('n', 'nn', '<Plug>(gin-action-new)')
    _G.TKC.utils.nvim.buffer_keymap({'n','v'}, 'yy', '<Plug>(gin-action-yank:branch)')
    _G.TKC.utils.nvim.buffer_keymap({'n','v'}, 'a', '<Plug>(gin-action-choice)')
    _G.TKC.utils.nvim.buffer_keymap({'n','v'}, 'dd', '<Plug>(gin-action-delete)')
  end
}
