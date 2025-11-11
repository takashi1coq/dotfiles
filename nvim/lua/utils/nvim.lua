
return {
  clipboard = function (word, showMessage)
    local w = tostring(word)
    vim.fn.setreg('+', w)
    vim.fn.setreg('"', w)
    if showMessage then
      print('Yanked to clipboard => [ '..w..' ]')
    end
  end
  , floating_window_default_width = 60
  , floating_window_default_height = 5
  , open_floating_window_with_text = function (text, position)
    position = position or 'center'
    local lines = _G.TKC.utils.table.string_to_table(text, '\n')
    local max_width = _G.TKC.utils.nvim.floating_window_default_width
    for _, line in ipairs(lines) do
      local line_width = vim.fn.strdisplaywidth(line)
      if line_width > max_width then
          max_width = line_width
      end
    end
    local editor_width = vim.o.columns
    local editor_height = vim.o.lines
    local width = max_width
    local height = math.max(
      math.min(#lines, editor_height - 10)
      , _G.TKC.utils.nvim.floating_window_default_height
    )
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
  end
  , open_empty_buffer = function (opener)
    opener = opener or 'tabnew'
    vim.cmd(opener..' | setlocal nobuflisted buftype=nofile bufhidden=wipe noswapfile')
  end
  , quit = function ()
    local bufNumber = vim.api.nvim_get_current_buf()
    local lastWinNumber = vim.fn.winnr('$')
    local lastTabNumber = vim.fn.tabpagenr('$')
    local targetTabNumber = vim.fn.tabpagenr()
    local isDiff = vim.wo.diff
    local isModified = vim.bo[bufNumber].modified
    local function tabclose()
      vim.cmd('tabclose!')
      if
        -- tab exists after current tab
        targetTabNumber < lastTabNumber
        -- not current tab is not leftmost tab
        and not (targetTabNumber == 1)
        -- not multiple tabs open
        and not (lastTabNumber == 1)
        -- only window, or diff mode
        and (lastWinNumber == 1 or isDiff)
      then
        vim.cmd('tabprev')
      end
    end
    local function last_tabclose()
      local quitChoice = vim.fn.confirm("This is the last tab. Quit Neovim?", "&Yes\n&No", 2)
      if quitChoice == 1 then
        vim.cmd('qa!')
      elseif quitChoice == 2 then
        return
      end
    end
    -- if diff mode
    if isDiff then
      if lastTabNumber == 1 then
        last_tabclose()
        return
      end
      tabclose()
      return
    end
    -- Buffer is modified
    if isModified then
      local choice = vim.fn.confirm('Buffer is modified. Save before closing?', '&Yes\n&No', 2)
      if choice == 1 then
        vim.cmd('write')
      elseif choice == 2 then
        return
      end
    end
    -- nomal
    if lastWinNumber > 1 then
      vim.cmd('close')
      return
    end
    -- last tab
    if lastTabNumber == 1 then
      last_tabclose()
      return
    end
    -- tabclose and tabprev
    tabclose()
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
    _G.TKC.utils.message.open_floating_message_window(
      'Show diff of the following file'
      , left
      , right
    )
  end
  , command_complete = function (t)
    return function (arg_lead)
      return vim.tbl_filter(
        function(item)
          return vim.startswith(item, arg_lead)
        end
        , t
      )
    end
  end
  , search = function(text)
    vim.fn.setreg('/', text)
    vim.cmd('normal! n')
  end
  , disable_search_highlight = function()
    vim.cmd('nohlsearch')
  end
}
