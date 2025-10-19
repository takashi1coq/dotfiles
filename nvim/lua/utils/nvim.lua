
return {
  win_one = function ()
    if vim.wo.diff then
      return
    end
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
  , clipboard = function (word, showMessage)
    local w = tostring(word)
    vim.fn.setreg('+', w)
    vim.fn.setreg('"', w)
    if showMessage then
      print('Yanked to clipboard => [ '..w..' ]')
    end
  end
  , open_floating_window_with_text = function (text, position)
    position = position or 'center'
    local lines = _G.TKC.utils.table.string_to_table(text, '\n')
    local max_width = 0
    for _, line in ipairs(lines) do
      local line_width = vim.fn.strdisplaywidth(line)
      if line_width > max_width then
          max_width = line_width
      end
    end
    local editor_width = vim.o.columns
    local editor_height = vim.o.lines
    local width = max_width + 2
    local height = #lines + 2
    local row = math.floor((editor_height - height) / 2)
    local col = 0
    if position == 'left' then
      col = 2
    elseif position == 'right' then
      col = editor_width - width - 2
    else
      col = math.floor((editor_width - width) / 2)
    end
    local buffer = vim.api.nvim_create_buf(false, true)
    vim.api.nvim_buf_set_lines(buffer, 0, -1, false, lines)
    local window_id = vim.api.nvim_open_win(buffer, true, {
      relative = 'editor'
      , width = width
      , height = height
      , row = row
      , col = col
      , style = 'minimal'
      , border = 'rounded'
    })
    vim.api.nvim_win_set_option(window_id, 'wrap', false)
    return window_id
  end
  , open_empty_buffer = function (opener)
    opener = opener or 'tabnew'
    vim.cmd(opener..' | setlocal nobuflisted buftype=nofile bufhidden=wipe noswapfile')
  end
  , quit = function ()
    local lastWinNr = vim.fn.winnr('$')
    local targetTabNr = vim.fn.tabpagenr()
    local lastTabNr = vim.fn.tabpagenr('$')
    local isDiff = vim.wo.diff
    if lastWinNr == 1 or isDiff then
      vim.cmd('tabclose!')
    else
      vim.cmd('q')
    end
    if (lastWinNr == 1 or isDiff) and not(targetTabNr == 1) and not(lastTabNr == 1) and targetTabNr < lastTabNr then
      vim.cmd('tabprev')
    end
  end
  , get_visual = function ()
    local result = ''
    local mode = vim.fn.mode()
    if mode == 'v' or mode == 'V' then
      local memo = vim.fn.getreginfo('z')
      vim.cmd('noautocmd normal! "zygv')
      local reginfo = vim.fn.getreginfo('z')
      vim.fn.setreg('z', memo)
      result = table.concat(reginfo.regcontents)
    end
    return result
  end
  , set_visual = function (word)
    local w = tostring(word)
    local mode = vim.fn.mode()
    if mode == 'v' or mode == 'V' then
      local memo = vim.fn.getreginfo('z')
      vim.fn.setreg('z', w)
      vim.cmd('noautocmd normal! "zp')
      vim.fn.setreg('z', memo)
    end
  end
  , reload = function ()
    local currentTab = vim.api.nvim_get_current_tabpage()
    local buffers = vim.api.nvim_list_bufs()
    for _, bufferNumber in ipairs(buffers) do
      local name = vim.api.nvim_buf_get_name(bufferNumber)
      local isLoaded = vim.api.nvim_buf_is_loaded(bufferNumber)
      local bufferType = vim.api.nvim_buf_get_option(bufferNumber, 'buftype')
      local listed = vim.api.nvim_buf_get_option(bufferNumber, 'buflisted')
      if isLoaded and listed and bufferType ~= 'terminal' then
        if name ~= '' and vim.fn.filereadable(name) == 1 then
          pcall(function ()
            vim.api.nvim_buf_call(bufferNumber, function () vim.cmd('e!') end)
          end)
        else
          pcall(function ()
            vim.api.nvim_buf_delete(bufferNumber, { force = true })
          end)
        end
      end
    end
    vim.api.nvim_set_current_tabpage(currentTab)
  end
  , buffer_keymap = function (mode, key, callback, option)
    option = option or {}
    option['buffer'] = true
    vim.keymap.set(mode, key, callback, option)
  end
  , replace_in_buffer = function (what, with)
    local bufferNumber = vim.api.nvim_get_current_buf()
    local lines = vim.api.nvim_buf_get_lines(bufferNumber, 0, -1, false)
    local pattern = what:gsub([[([%^%$%(%)%%%.%[%]%*%+%-%?])]], [[%%%1]])
    for i, line in ipairs(lines) do
      lines[i] = line:gsub(pattern, with)
    end
    vim.api.nvim_buf_set_lines(bufferNumber, 0, -1, false, lines)
  end
  , create_augroup = function (fileTypeList, name)
    vim.api.nvim_create_augroup(name, {})
    vim.api.nvim_create_autocmd('FileType', {
      group = name
      , pattern = '*'
      , callback = function(args)
        local func = setmetatable(fileTypeList, {
          __index = function()
            return function() end
          end
        })
        func[args.match]()
      end
    })
  end
  , open_tab = function (path)
    vim.cmd('tabe '..vim.fn.expand(path))
  end
  , diff = function (left, right)
    left = left or 'left'
    right = right or 'right'
    if left == 'left' then
      _G.TKC.utils.nvim.open_empty_buffer('tabnew '..left..'|diffthis')
    else
      vim.cmd('tabnew '..left..'|diffthis')
    end
    if right == 'right' then
      _G.TKC.utils.nvim.open_empty_buffer('vsplit '..right..'|diffthis')
    else
      vim.cmd('vsplit '..right..'|diffthis')
    end
    vim.cmd('wincmd w')
  end
}
