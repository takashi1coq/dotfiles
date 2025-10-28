
-- line number
vim.o.number = true
-- no swapfile
vim.o.swapfile = false
-- create undofile to /tmp
vim.o.undofile = true
vim.o.undodir = vim.fn.stdpath('data')
-- case-insensitive
vim.o.ignorecase = true
-- disable hiding of double quotes in JSON
vim.o.conceallevel = 0
-- wrap around to top when search
vim.o.wrapscan = true
-- encodeing detection priority
vim.o.fileencodings = 'utf-8,euc-jp,ucs-bom,iso-2022-jp,sjis,cp932,latin1'
-- always tabline
vim.o.showtabline = 2
-- Enable using the system clipboard
vim.opt.clipboard:append {'unnamedplus'}
-- tab, space visualization
vim.o.list = true
vim.o.listchars = [[tab:>-,trail:_,extends:>,precedes:<]]
-- tab is 2space
vim.o.expandtab = true
vim.o.tabstop = 2
vim.o.softtabstop = 2
vim.o.shiftwidth = 2
-- cursor highlite
vim.o.cursorline = true
-- split right
vim.o.splitright = true
-- mouse, nomal mode only
vim.o.mouse = 'n'
-- help open in a new tab
vim.cmd([[
  cabbrev help tab help
  cabbrev h tab h
]])
-- E518
-- vim.api.nvim_set_option('modeline', false)
