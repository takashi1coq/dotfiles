vim.g['memolist_path'] = '~/work/memo/docs/mkmemo'
vim.g['memolist_memo_date'] = '%Y-%m-%d'

vim.keymap.set('n', 'ml', function () vim.fn['ddu#start']({
  ui = 'ff'
  , sources = {{ name = 'file_rec' }}
  , uiParams = { ff = { startFilter = true } }
  , sourceOptions = {
    file_rec = {
      path = vim.fn.expand(vim.g['memolist_path'])
    }
  }
}) end)
vim.keymap.set('n', 'mn', function () vim.cmd([[MemoNew]]) end)
