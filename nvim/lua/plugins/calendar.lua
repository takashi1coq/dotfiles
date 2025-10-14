vim.api.nvim_create_user_command(
  'Calendar'
  , function ()
    _G.TKC.utils.nvim.open_floating_window_with_text(require("calendar").getCalendar(), 'right')
  end
  , { nargs = 0 }
)
