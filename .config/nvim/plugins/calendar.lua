vim.api.nvim_create_user_command(
  'Calendar'
  , function ()
    vim.fn.openFloatingWindowWithText(require("calendar").getCalendar())
  end
  , { nargs = 0 }
)
