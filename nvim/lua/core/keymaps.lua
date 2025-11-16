--[[==========================================================
 main
============================================================]]

-- n,v mode swap ; and :
vim.keymap.set({'n','v'}, ';', ':')
vim.keymap.set({'n','v'}, ':', ';')

-- use ;; to open command history
vim.keymap.set('n', ';;', 'q:')

-- use // to open search history
vim.keymap.set('n', '//', 'q/')

-- command output in a floating window
vim.keymap.set('n', '<Space>;', ':OutputInFloating ')

-- paste
vim.keymap.set({'i','c'}, '<C-v>', '<C-r>+')
vim.keymap.set('t', '<C-v>', [[<C-\><C-n>pi]])

-- p doesn't change the register
vim.keymap.set('x', 'p', 'pgvy')

-- insert datetime
vim.keymap.set(
  'i', '<C-d>'
  , function ()
    local date = _G.TKC.utils.datetime.locale_date()
    local day_of_week = _G.TKC.utils.datetime.day_of_week()
    local text = string.format([[%s (%s)]], date, day_of_week)
    vim.api.nvim_put({text}, 'c', true, true)
  end
)

-- C-t for insert untypable characters (literal input)
vim.keymap.set({'i','c'}, '<C-t>', '<C-v>')

-- aa for select all
vim.keymap.set('n', 'aa', 'ggVG$')

-- wrap the selected text with delimiters ',",(,{,[
vim.keymap.set('v', "'", "c''<ESC>P")
vim.keymap.set('v', '"', 'c""<ESC>P')
vim.keymap.set('v', "(", "c()<ESC>P")
vim.keymap.set('v', '{', 'c{}<ESC>P')
vim.keymap.set('v', '[', 'c[]<ESC>P')

-- non-yanking delete with x
vim.keymap.set('n', 'x', '"_x')

-- move one line at a time, even on wrapped lines
vim.keymap.set('n', 'j', 'gj')
vim.keymap.set('n', 'k', 'gk')

-- move
vim.keymap.set({'n','v'}, 'H', 'b')
vim.keymap.set({'n','v'}, 'L', 'w')
vim.keymap.set({'n','v'}, 'J', '10j')
vim.keymap.set({'n','v'}, 'K', '10k')
vim.keymap.set('n', '<C-f>', '13<C-e>')
vim.keymap.set('n', '<C-u>', '13<C-y>')

-- exchange jump backward,forward
vim.keymap.set('n', '<C-o>', '<C-i>zz')
vim.keymap.set('n', '<C-i>', '<C-o>zz')

-- dot commnad to selected renge
vim.keymap.set('v', '.', ":'<,'>normal .<CR>")

-- overwrite TAB in normal mode
vim.keymap.set('n', '<TAB>', '4l')

--[[==========================================================
 search
============================================================]]

-- set highlight and, use <ESC><ESC> to clear highlight
vim.cmd('set hlsearch')
vim.keymap.set('n', '<ESC><ESC>', function () vim.cmd('nohlsearch') end)

-- * for word search
vim.keymap.set('v', '*', '"zy:let @/ = @z<CR>n')

-- center the search result
vim.keymap.set('n', 'n', 'nzz')
vim.keymap.set('n', 'N', 'Nzz')
vim.keymap.set('n', '*', '*zz')
vim.keymap.set('n', '#', '#zz')

--[[==========================================================
 window
============================================================]]

-- change window size
vim.keymap.set('n', '<Up>', '<C-w>-')
vim.keymap.set('n', '<Down>', '<C-w>+')
vim.keymap.set('n', '<Right>', '<C-w><')
vim.keymap.set('n', '<Left>', '<C-w>>')

-- window (buffer) close
vim.keymap.set('n', 'q', function () _G.TKC.utils.nvim.quit() end)

-- equalize window size
vim.keymap.set('n', '==', '<C-w>=')


--[[==========================================================
 tabpage
============================================================]]

-- tt for open new tab
vim.keymap.set('n', 'tt', function () _G.TKC.utils.nvim.open_empty_buffer() end)

-- C-l,h for tab move
vim.keymap.set('n', '<C-l>', 'gt')
vim.keymap.set('n', '<C-h>', 'gT')

-- close all other tabs
vim.keymap.set('n', 'to', function () vim.cmd('tabo') end)

-- move tab to another position
vim.keymap.set('n', '<S-Left>', function () vim.cmd('tabm -1') end)
vim.keymap.set('n', '<S-Right>', function () vim.cmd('tabm +1') end)

--[[==========================================================
 terminal
============================================================]]

-- use ESC to exit insert mode
vim.keymap.set('t', '<ESC>', [[<C-\><C-n>]])
-- open terminal in current project
vim.keymap.set(
  'n', '<Space>j'
  , function ()
    _G.TKC.utils.terminal.my(
      _G.TKC.utils.file.project_name()
      , nil
      , nil
      , 'botright new'
    )
  end
)

--[[==========================================================
 custom operation
============================================================]]

-- Calculate selected range
vim.keymap.set(
  'v', '=='
  , function ()
    local text = _G.TKC.utils.nvim.get_visual()
    local calcFunction, error = load('return '..text)
    if not calcFunction then
      vim.notify('Invalid expression: '..error, vim.log.levels.ERROR)
      return
    end
    local ok, result = pcall(calcFunction)
    if not ok then
      vim.notify('calcFunction ERROR: '..result, vim.log.levels.ERROR)
      return
    end
    vim.api.nvim_put({tostring(result)}, 'l', true, true)
  end
)

-- exchange selected renge
vim.keymap.set(
  'v', 'rr'
  , function ()
    local visualText = _G.TKC.utils.nvim.get_visual()
    _G.TKC.utils.nvim.search(visualText)
    local buf = vim.api.nvim_create_buf(false, true)
    vim.api.nvim_buf_set_lines(buf, 0, -1, false, {visualText, ""})
    local width = math.max(
      _G.TKC.utils.nvim.floating_window_default_width
      , #visualText + 5
    )
    local win = vim.api.nvim_open_win(buf, true, {
      relative = 'editor'
      , width = width
      , height = 2
      , row = math.floor(vim.o.lines / 2) - 1
      , col = math.floor((vim.o.columns - width) / 2)
      , style = 'minimal'
      , border = 'single'
    })
    vim.api.nvim_win_set_cursor(win, {2, 0})
    vim.cmd('startinsert')
    vim.keymap.set('i', '<CR>', function()
      local inputLines = vim.api.nvim_buf_get_lines(buf, 0, -1, false)
      local what = inputLines[1] or ""
      local with = inputLines[2] or ""
      vim.api.nvim_win_close(win, true)
      vim.cmd('stopinsert')
      _G.TKC.utils.nvim.replace_in_buffer(what, with)
      _G.TKC.utils.nvim.disable_search_highlight();
    end, { buffer = buf })
    vim.keymap.set('n', 'q', function()
      _G.TKC.utils.nvim.quit()
      _G.TKC.utils.nvim.disable_search_highlight();
    end, { buffer = buf })
  end
)

-- snake case to camel case
vim.keymap.set(
  'v', 'sc'
  , function ()
    _G.TKC.utils.nvim.set_visual(
      _G.TKC.utils.string.snake_to_camel_case(
        _G.TKC.utils.nvim.get_visual()
      )
    )
  end
)

-- camel case to snake case
vim.keymap.set(
  'v', 'cs'
  , function ()
    _G.TKC.utils.nvim.set_visual(
      _G.TKC.utils.string.camel_to_snake_case(
        _G.TKC.utils.nvim.get_visual()
      )
    )
  end
)
