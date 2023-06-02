vim.cmd("autocmd!")

local autoCmd = vim.api.nvim_create_autocmd

autoCmd(
  'BufWritePre'
  , {
    pattern = '*'
    , command = [[:%s/\s\+$//ge]]
  }
)

autoCmd(
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

autoCmd(
  'TermOpen'
  , {
    pattern = '*'
    , callback = function ()
        vim.cmd([[startinsert]])
        vim.cmd([[setlocal isk+=-]])
      end
  }

)
