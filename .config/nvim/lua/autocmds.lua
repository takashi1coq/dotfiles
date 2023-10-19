vim.cmd("autocmd!")

vim.api.nvim_create_autocmd(
  'BufWritePre'
  , {
    pattern = '*'
    , command = [[:%s/\s\+$//ge]]
  }
)

vim.api.nvim_create_autocmd(
  'BufEnter'
  , {
    pattern = '*'
    , callback = function ()
        local buftype = vim.o.buftype
        if IsEmpty(buftype) then
          vim.cmd([[WinOne]])
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
