local memoPath = vim.fn.expand('~/work/memo/docs/mkmemo')

vim.keymap.set('n', 'mn', function ()
  local title = vim.fn.input('memo title ? : ')
  if string.isEmpty(title) then
    return
  end
  local header = string.implode({
    title
    , [[==========]]
  }, '\n')
  local filePath = string.implode({
    memoPath
    , os.yyyymmddhhmmss()..'.md'
  }, '/')
  vim.fn.customFileCreate(header, filePath)
end)

vim.keymap.set('n', 'ml', function ()
  vim.fn.openCustomDirectory(memoPath, true)
end)
