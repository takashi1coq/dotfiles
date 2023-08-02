-- 行番号
vim.api.nvim_set_option('relativenumber', true)

-- スワップファイルを作成しない
vim.api.nvim_set_option('swapfile', false)

-- undoFileを/tmpに作成
vim.api.nvim_set_option('undofile', true)
vim.api.nvim_set_option('undodir', '/tmp')

-- 大文字小文字を区別しない
vim.api.nvim_set_option('ignorecase', true)

-- 非表示設定をすべてOFF(jsonのダブルコーテーション表示用)
vim.api.nvim_set_option('conceallevel', 0)

-- 一番下までいったら上に戻る
vim.api.nvim_set_option('wrapscan', true)

-- エンコード
vim.api.nvim_set_option('fileencodings', 'utf-8,euc-jp,ucs-bom,iso-2022-jp,sjis,cp932,latin1')

-- tablineを常に表示
vim.api.nvim_set_option('showtabline', 2)

-- クリップボード共有
vim.opt.clipboard:append {'unnamedplus'}

-- <Tab> <Space> 等可視化
vim.api.nvim_set_option('list', true)
vim.api.nvim_set_option('listchars', 'tab:>-,trail:_,extends:>,precedes:<')

-- <Tab>を<Space>2
vim.api.nvim_set_option('expandtab', true)
vim.api.nvim_set_option('tabstop', 2)
vim.api.nvim_set_option('softtabstop', 2)
vim.api.nvim_set_option('shiftwidth', 2)

-- カーソル行をハイライト
vim.api.nvim_set_option('cursorline', true)

-- 右にスプリット
vim.api.nvim_set_option('splitright', true)

-- マウス操作ON
vim.api.nvim_set_option('mouse', 'n')

-- ヘルプをタブで開くようにする
vim.cmd([[
  cabbrev help tab help
  cabbrev h tab h
]])
