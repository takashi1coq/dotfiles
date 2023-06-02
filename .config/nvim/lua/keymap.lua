-- mode -> :h map
local keymapSet = vim.keymap.set
local vimCmd = vim.cmd

--[[==========================================================
 main
============================================================]]

-- n,vモード時のみ;と:を入れ替える
keymapSet({'n','v'}, ';', ':')
keymapSet({'n','v'}, ':', ';')

-- コマンド履歴
keymapSet('n', ';;', 'q:', { nowait = 1 })

-- 検索履歴
keymapSet('n', '//', 'q/')

-- 貼り付け
keymapSet({'i','c'}, '<C-v>', '<C-r>+')
keymapSet('t', '<C-v>', [[<C-\><C-n>pi]])

-- Ctrl-p で差し替え後もペースト
keymapSet('v', '<C-p>', '"0p<CR>')

-- insert datetime TODO lua function..
keymapSet('i', '<C-d>', '<C-r>=strftime("%Y%m%d (%a)")<CR>')

-- コード変換をC-t
keymapSet({'i','c'}, '<C-t>', '<C-v>')

-- "aaで全選択
keymapSet('n', 'aa', 'ggVG$')

-- 選択範囲を囲む
keymapSet('v', "'", "xi''<ESC>P")
keymapSet('v', '"', 'xi""<ESC>P')

-- x削除でレジスタに格納しない
keymapSet('n', 'x', '"_x')

-- wrap設定の場合、一行づつ移動する
keymapSet('n', 'j', 'gj')
keymapSet('n', 'k', 'gk')

-- 移動
keymapSet({'n','v'}, 'H', 'b')
keymapSet({'n','v'}, 'L', 'w')
keymapSet({'n','v'}, 'J', '10j')
keymapSet({'n','v'}, 'K', '10k')
keymapSet('n', '<C-f>', '13<C-e>')
keymapSet('n', '<C-u>', '13<C-y>')

-- 進む、戻るを逆に
keymapSet('n', '<C-o>', '<C-i>zz')
keymapSet('n', '<C-i>', '<C-o>zz')

-- 選択業にdot command TODO lua function..
keymapSet('v', '.', ":'<,'>normal .<CR>")

-- keywordにハイフンを含める
keymapSet('n', '--', function () vimCmd('setlocal isk+=-') end)

--[[==========================================================
 seach
============================================================]]

-- 検索ハイライト
vimCmd('set hlsearch')
keymapSet('n', '<ESC><ESC>', function () vimCmd('nohlsearch') end)

-- *で単語検索
keymapSet('v', '*', '"zy:let @/ = @z<CR>n')

-- 検索結果を中央表示
keymapSet('n', 'n', 'nzz')
keymapSet('n', 'N', 'Nzz')
keymapSet('n', '*', '*zz')
keymapSet('n', '#', '#zz')

--[[==========================================================
 window
============================================================]]

-- サイズ変更
keymapSet('n', '<Up>', '<C-w>-')
keymapSet('n', '<Down>', '<C-w>+')
keymapSet('n', '<Right>', '<C-w><')
keymapSet('n', '<Left>', '<C-w>>')

-- 閉じる
keymapSet('n', 'q', function() vimCmd('MyQuit') end)

-- windowサイズをそろえる
keymapSet('n', '==', '<C-w>=')


--[[==========================================================
 tabpage
============================================================]]

-- 新しいタブ
keymapSet('n', 'tt', function () vimCmd('tabnew') end)

-- タブ移動
keymapSet('n', '<C-l>', 'gt')
keymapSet('n', '<C-h>', 'gT')

-- "アクティブ以外閉じるをto
keymapSet('n', 'to', function () vimCmd('tabo') end)

-- タブそのものを移動 TODO ボタン決める

--[[==========================================================
 terminal
============================================================]]

-- escでinsert modeから抜ける
keymapSet('t', '<ESC>', [[<C-\><C-n>]])




