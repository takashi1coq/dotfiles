vim.api.nvim_create_user_command(
  'Calendar'
  , function ()
    local text = require("calendar").getCalendar()
    local winBuf = vim.fn.openFloatingWindow()
    vim.api.nvim_buf_set_lines(winBuf, 0, -1, false, vim.split(text, '\n'))
  end
  , { nargs = 0 }
)
