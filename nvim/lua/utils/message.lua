
return {
  error = function (...)
    vim.notify(_G.TKC.utils.string.inspect_and_join(...), vim.log.levels.ERROR)
  end
  , warning = function (...)
    vim.notify(_G.TKC.utils.string.inspect_and_join(...), vim.log.levels.WARN)
  end
  , info = function (...)
    vim.notify(_G.TKC.utils.string.inspect_and_join(...), vim.log.levels.INFO)
  end
  , open_floating_message_window = function (...)
    local lines = _G.TKC.utils.table.inspect_and_join(...)
    local padding = 2
    local max_len = 0
    for _, l in ipairs(lines) do
      local len = vim.fn.strdisplaywidth(l)
      if len > max_len then max_len = len end
    end
    local width = math.min((max_len + padding * 2), (vim.o.columns - 4))
    local height = math.min((#lines + padding * 2), (vim.o.lines - 4))
    local row = math.floor((vim.o.lines - height) / 2)
    local col = math.floor((vim.o.columns - width) / 2)
    local buf = vim.api.nvim_create_buf(false, true)
    vim.api.nvim_buf_set_option(buf, 'bufhidden', 'wipe')
    vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
    local win_opts = {
      relative = 'editor',
      row = row,
      col = col,
      width = width,
      height = height,
      style = 'minimal',
      border = 'rounded',
      focusable = true,
    }
    local win = vim.api.nvim_open_win(buf, true, win_opts)
    vim.keymap.set('n', '<CR>', function()
      if vim.api.nvim_win_is_valid(win) then vim.api.nvim_win_close(win, true) end
    end, { buffer = buf, silent = true })
    vim.keymap.set('n', 'q', function()
      if vim.api.nvim_win_is_valid(win) then vim.api.nvim_win_close(win, true) end
    end, { buffer = buf, silent = true })
  end
}
