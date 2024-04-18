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

-- 貼り付け
vim.keymap.set({'i','c'}, '<C-v>', '<C-r>+')
vim.keymap.set('t', '<C-v>', [[<C-\><C-n>pi]])

-- Ctrl-p で差し替え後もペースト
vim.keymap.set('v', '<C-p>', '"0p<CR>')

-- insert datetime TODO lua function..
vim.keymap.set('i', '<C-d>', '<C-r>=strftime("%Y%m%d (%a)")<CR>')

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
vim.keymap.set('n', 'q', function () vim.fn.myQuit() end)

-- windowサイズをそろえる
vim.keymap.set('n', '==', '<C-w>=')


--[[==========================================================
 tabpage
============================================================]]

-- 新しいタブ
vim.keymap.set('n', 'tt', function () vim.fn.openEmptyBuffer() end)

-- タブ移動
vim.keymap.set('n', '<C-l>', 'gt')
vim.keymap.set('n', '<C-h>', 'gT')

-- "アクティブ以外閉じるをto
vim.keymap.set('n', 'to', function () vim.cmd('tabo') end)

-- タブそのものを移動 TODO ボタン決める

--[[==========================================================
 terminal
============================================================]]

-- escでinsert modeから抜ける
vim.keymap.set('t', '<ESC>', [[<C-\><C-n>]])

--[[==========================================================
 macro
 ============================================================]]

vim.keymap.set('n', '<F9>', 'qm')
vim.keymap.set('n', '<F10>', '@m')

--[[==========================================================
 function
============================================================]]

-- translate-shell
local function translate (slLang, tlLang)
  local visualStr = vim.fn.getVisual()
  visualStr = visualStr:gsub('"', '')
  local result = vim.fn.system('trans -b -sl='..slLang..' -tl='..tlLang..' '.. '"'.. visualStr.. '"')
  vim.fn.openFloatingWindowWithText(result)
end
vim.keymap.set('v', '<F1>', function () translate('en','ja') end)
vim.keymap.set('v', '<F2>', function () translate('ja','en') end)

-- refresh
vim.keymap.set(
  'n', '<F4>'
  , function ()
    local tabnr = vim.fn.tabpagenr()
    vim.cmd('tabdo e!')
    vim.cmd('tabnext '..tabnr)

    local bufnrs = vim.fn.range(1, vim.fn.bufnr("$"))
    local deleteBufners = table.filter(function (v)
      local isBufexists = vim.fn.bufexists(vim.fn.bufname(v)) == 1
      local isFilereadable = vim.fn.filereadable(vim.fn.expand("#"..v..":p")) == 1
      local isBuflisted = vim.fn.buflisted(v) == 1
      local isTerminal = vim.fn.getbufvar(v, '&buftype') == 'terminal'
      return isBufexists and not(isFilereadable) and isBuflisted and not(isTerminal)
    end, bufnrs)
    for i in ipairs(deleteBufners) do
      vim.cmd('bd '..deleteBufners[i])
    end
  end
)
-- show message
vim.keymap.set(
  'n', '<F12>'
  , function () vim.cmd('Messages') end
)

-- toggle case
local function ToggleWordCase(word)
  local result = word
  if word:find('[a-z][A-Z]') then
    result = word:gsub('([a-z])([A-Z])', '%1_%2'):lower()
  elseif word:find('_[a-z]') then
    result = word:gsub('(_)([a-z])', function(_, l) return l:upper() end)
  elseif word:find('-[a-z]') then
    result = word:gsub('(-)([a-z])', function(_, l) return l:upper() end)
  end
  return result
end
local function ChangeWordCaseHyphen(word)
  local result = word
  if word:find('[a-z][A-Z]') then
    result = word:gsub('([a-z])([A-Z])', '%1-%2'):lower()
  elseif word:find('_[a-z]') then
    result = word:gsub('(_)([a-z])', function(_, l) return '-'..l end)
  end
  return result
end
vim.keymap.set(
  'v', 'cc'
  , function ()
    vim.fn.setVisual(ToggleWordCase(vim.fn.getVisual()))
  end
)
vim.keymap.set(
  'v', '--'
  , function ()
    vim.fn.setVisual(ChangeWordCaseHyphen(vim.fn.getVisual()))
  end
)
vim.keymap.set(
  'v', '=='
  , function ()
    local func = assert(load("return " .. vim.fn.getVisual()))
    vim.fn.setVisual(func())
  end
)

