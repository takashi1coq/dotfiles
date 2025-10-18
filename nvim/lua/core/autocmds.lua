
vim.api.nvim_create_autocmd(
  'BufEnter'
  , {
    pattern = '*'
    , callback = function ()
      if not vim.wo.diff then
        _G.TKC.utils.nvim.win_one()
      end
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
