--[[==========================================================
 main
============================================================]]

-- n,vモード時のみ;と:を入れ替える
vim.keymap.set({'n','v'}, ';', ':')
vim.keymap.set({'n','v'}, ':', ';')

-- コマンド履歴
vim.keymap.set('n', ';;', 'q:')

-- 検索履歴
vim.keymap.set('n', '//', 'q/')

-- command output in a floating window
vim.keymap.set('n', '<Space>;', ':OutputInFloating ')

-- 貼り付け
vim.keymap.set({'i','c'}, '<C-v>', '<C-r>+')
vim.keymap.set('t', '<C-v>', [[<C-\><C-n>pi]])

-- p doesn't change the register
vim.keymap.set('x', 'p', 'pgvy')

-- insert date time
vim.keymap.set(
  'i', '<C-d>'
  , function ()
    local date = _G.TKC.utils.datetime.locale_date()
    local day_of_week = _G.TKC.utils.datetime.day_of_week()
    local text = string.format([[%s (%s)]], date, day_of_week)
    vim.api.nvim_put({text}, 'c', true, true)
  end
)

-- コード変換をC-t
vim.keymap.set({'i','c'}, '<C-t>', '<C-v>')

-- "aaで全選択
vim.keymap.set('n', 'aa', 'ggVG$')

-- 選択範囲を囲む
vim.keymap.set('v', "'", "c''<ESC>P")
vim.keymap.set('v', '"', 'c""<ESC>P')
vim.keymap.set('v', "(", "c()<ESC>P")
vim.keymap.set('v', '{', 'c{}<ESC>P')
vim.keymap.set('v', '[', 'c[]<ESC>P')

-- x削除でレジスタに格納しない
vim.keymap.set('n', 'x', '"_x')

-- wrap設定の場合、一行づつ移動する
vim.keymap.set('n', 'j', 'gj')
vim.keymap.set('n', 'k', 'gk')

-- 移動
vim.keymap.set({'n','v'}, 'H', 'b')
vim.keymap.set({'n','v'}, 'L', 'w')
vim.keymap.set({'n','v'}, 'J', '10j')
vim.keymap.set({'n','v'}, 'K', '10k')
vim.keymap.set('n', '<C-f>', '13<C-e>')
vim.keymap.set('n', '<C-u>', '13<C-y>')

-- 進む、戻るを逆に
vim.keymap.set('n', '<C-o>', '<C-i>zz')
vim.keymap.set('n', '<C-i>', '<C-o>zz')

-- 選択業にdot command
vim.keymap.set('v', '.', ":'<,'>normal .<CR>")

-- normalでtabを上書き
vim.keymap.set('n', '<TAB>', '4l')

--[[==========================================================
 search
============================================================]]

-- 検索ハイライト
vim.cmd('set hlsearch')
vim.keymap.set('n', '<ESC><ESC>', function () vim.cmd('nohlsearch') end)

-- *で単語検索
vim.keymap.set('v', '*', '"zy:let @/ = @z<CR>n')

-- 検索結果を中央表示
vim.keymap.set('n', 'n', 'nzz')
vim.keymap.set('n', 'N', 'Nzz')
vim.keymap.set('n', '*', '*zz')
vim.keymap.set('n', '#', '#zz')

--[[==========================================================
 window
============================================================]]

-- サイズ変更
vim.keymap.set('n', '<Up>', '<C-w>-')
vim.keymap.set('n', '<Down>', '<C-w>+')
vim.keymap.set('n', '<Right>', '<C-w><')
vim.keymap.set('n', '<Left>', '<C-w>>')

-- 閉じる
vim.keymap.set('n', 'q', function () _G.TKC.utils.nvim.quit() end)

-- windowサイズをそろえる
vim.keymap.set('n', '==', '<C-w>=')


--[[==========================================================
 tabpage
============================================================]]

-- 新しいタブ
vim.keymap.set('n', 'tt', function () _G.TKC.utils.nvim.open_empty_buffer() end)

-- タブ移動
vim.keymap.set('n', '<C-l>', 'gt')
vim.keymap.set('n', '<C-h>', 'gT')

-- "アクティブ以外閉じるをto
vim.keymap.set('n', 'to', function () vim.cmd('tabo') end)

-- タブそのものを移動
vim.keymap.set('n', '<S-Left>', function () vim.cmd('tabm -1') end)
vim.keymap.set('n', '<S-Right>', function () vim.cmd('tabm +1') end)

--[[==========================================================
 terminal
============================================================]]

-- escでinsert modeから抜ける
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

vim.keymap.set(
  'v', 'rr'
  , function ()
    local visualText = _G.TKC.utils.nvim.get_visual()
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
    end, { buffer = buf })
  end
)
