local deinCachePath = vim.fn.expand('~/.cache/nvim/dein_lua')
local deinDir = deinCachePath..'/repos/github.com/Shougo/dein.vim'
local deinToml = '~/.config/nvim/dein_lua.toml'

if string.match(vim.o.runtimepath, 'dein.vim') == nil then
  if vim.fn.isdirectory(deinDir) == 0 then
    vim.fn.execute('!git clone https://github.com/Shougo/dein.vim '..deinDir)
  end
  vim.fn.execute('set runtimepath+='.. vim.fn.fnamemodify(deinDir, ':p'))
end

vim.g['dein#install_log_filename'] = '~/dein.log'

if vim.fn['dein#load_state'](deinCachePath) == 1 then
    vim.fn['dein#begin'](deinCachePath)
    vim.fn['dein#load_toml'](deinToml, {lazy = 0})
    vim.fn['dein#end']()
    vim.fn['dein#save_state']()
end

if vim.fn['dein#check_install']() == 1 then
  vim.fn['dein#install']()
end
