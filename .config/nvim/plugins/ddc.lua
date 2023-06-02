vim.fn['ddc#custom#patch_filetype'](
  {'lua', 'typescript'}
  , 'sources'
  , {'nvim-lsp'}
)
vim.fn['ddc#custom#patch_global']({
  ui = 'pum'
  , sources = { 'around' }
  , autoCompleteEvents = {
      'InsertEnter', 'TextChangedI', 'TextChangedP',
      'CmdlineEnter', 'CmdlineChanged', 'TextChangedT',
  }
  , sourceOptions = {
    _ = {
      matchers = { 'matcher_head' }
      , sorters = { 'sorter_rank' }
    }
    , ['nvim-lsp'] = {
      mark = ':LSP'
      , forceCompletionPattern = [[\.\w*|::\w*|->\w*]]
      , dup = 'force'
    }
    , around = {
      mark = ':AROUND'
    }
  }
})

vim.keymap.set('i', '<TAB>', function ()
  if vim.fn['pum#visible']() then
    return vim.fn['pum#map#insert_relative'](1, 'loop')
  else
    local col = vim.fn.col('.') - 1
    if col == 0 or vim.fn.getline('.'):sub(col, col):match('%s') then
      return '<TAB>'
    else
      return vim.fn['ddc#map#manual_complete']()
    end
  end
end, { expr = true })
vim.keymap.set('i', '<S-Tab>', [[<Cmd>call pum#map#insert_relative(-1)<CR>]])
vim.keymap.set('i', '<C-y>', [[<Cmd>call pum#map#confirm()<CR>]])

