
vim.api.nvim_create_autocmd(
  'BufEnter'
  , {
    pattern = '*'
    , callback = function ()
      vim.schedule(function()
        if not vim.wo.diff then
          local currentWinId = vim.fn.win_getid()
          local winList = vim.fn.win_findbuf(vim.fn.bufnr('%'))
          for _, winId in ipairs(winList) do
            if winId ~= currentWinId then
              vim.fn.win_gotoid(winId)
              vim.cmd('q')
            end
          end
          vim.fn.win_gotoid(currentWinId)
        end
      end)
    end
  }
)
vim.api.nvim_create_autocmd(
  'TermOpen'
  , {
    pattern = '*'
    , callback = function ()
        vim.cmd([[startinsert]])
        vim.cmd([[setlocal isk+=-]])
    end
  }
)
vim.api.nvim_create_autocmd(
  'FileType'
  , {
    pattern = '*'
    , callback = function ()
        vim.opt_local.formatoptions:remove {'r', 'o'}
    end
  }
)
vim.api.nvim_create_autocmd(
  'BufWritePre'
  , {
    pattern = '*'
    , callback = function (event)
      local dir = vim.fn.fnamemodify(event.match, ":p:h")
      if vim.fn.isdirectory(dir) == 0 then
        vim.fn.mkdir(dir, "p")
      end
    end
  }
)
